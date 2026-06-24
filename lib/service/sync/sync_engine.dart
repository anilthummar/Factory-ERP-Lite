import '../../core/enums/sync_status.dart';
import '../../core/sync/sync_module_type.dart';
import '../../core/sync/sync_operation.dart';
import '../../core/sync/sync_queue_item.dart';
import '../../core/sync/sync_result.dart';
import '../../utils/debug_log.dart';
import '../hive/hive_manager.dart';
import 'handlers/sync_handler_registry.dart';
import 'handlers/sync_module_handler.dart';
import 'queue/sync_queue_repository.dart';
import 'remote/sync_remote_data_source.dart';
import 'sync_config.dart';
import 'sync_conflict_resolver.dart';
import 'sync_module_registry.dart';

/// Orchestrates offline-first sync from Hive queue to the remote store.
class SyncEngine {
  /// Creates [SyncEngine].
  SyncEngine({
    required SyncQueueRepository queueRepository,
    required SyncRemoteDataSource remoteDataSource,
    required SyncHandlerRegistry handlerRegistry,
    HiveManager? hiveManager,
    DebugLog? debugLog,
    SyncConflictResolver? conflictResolver,
  })  : _queueRepository = queueRepository,
        _remoteDataSource = remoteDataSource,
        _handlerRegistry = handlerRegistry,
        _hiveManager = hiveManager ?? HiveManager.instance,
        _debugLog = debugLog ?? DebugLog.instance,
        _conflictResolver = conflictResolver ?? const SyncConflictResolver();

  final SyncQueueRepository _queueRepository;
  final SyncRemoteDataSource _remoteDataSource;
  final SyncHandlerRegistry _handlerRegistry;
  final HiveManager _hiveManager;
  final DebugLog _debugLog;
  final SyncConflictResolver _conflictResolver;

  bool _isProcessing = false;

  /// Whether a sync run is currently in progress.
  bool get isProcessing => _isProcessing;

  /// Processes all pending and retry-eligible failed queue items.
  Future<SyncEngineReport> processPending() async {
    if (!_hiveManager.isInitialized || _isProcessing) {
      return const SyncEngineReport();
    }

    _isProcessing = true;
    await _touchMeta(SyncConfig.lastSyncAttemptAtKey);

    int succeededCount = 0;
    int failedCount = 0;
    int conflictCount = 0;
    try {
      final List<SyncQueueItem> items =
          await _queueRepository.getProcessableItems();

      for (final SyncQueueItem item in items) {
        final SyncResult result = await _processItem(item);
        if (result is SyncSuccess) {
          succeededCount++;
        } else if (result is SyncFailure) {
          failedCount++;
        } else if (result is SyncConflict) {
          conflictCount++;
        }
      }

      if (succeededCount > 0) {
        await _touchMeta(SyncConfig.lastSuccessfulSyncAtKey);
      }
    } finally {
      _isProcessing = false;
    }

    return SyncEngineReport(
      succeededCount: succeededCount,
      failedCount: failedCount,
      conflictCount: conflictCount,
    );
  }

  Future<SyncResult> _processItem(SyncQueueItem item) async {
    final SyncModuleHandler? handler = _handlerRegistry.handlerFor(item.module);
    if (handler == null) {
      return _markFailure(
        item,
        'No sync handler registered for module ${item.module.name}.',
        isRetryable: false,
      );
    }

    final SyncQueueItem processingItem = item.copyWith(
      status: SyncQueueItemStatus.processing,
      updatedAt: DateTime.now(),
    );
    await _queueRepository.save(processingItem);

    final Map<String, dynamic>? payload =
        await handler.loadPayload(item.recordId);
    if (payload == null) {
      await _queueRepository.remove(item.queueId);
      _debugLog.w(
        'Removed orphaned sync queue item ${item.queueId}: record missing locally.',
      );
      return SyncSuccess(queueItem: item);
    }

    final SyncResult result = await _remoteDataSource.push(item, payload);
    return _handleResult(handler, result, payload);
  }

  Future<SyncResult> _handleResult(
    SyncModuleHandler handler,
    SyncResult result,
    Map<String, dynamic> localPayload,
  ) async {
    if (result is SyncSuccess) {
      await handler.updateRecordSyncStatus(
        result.queueItem.recordId,
        SyncStatus.synced,
      );
      await _queueRepository.remove(result.queueItem.queueId);
      return result;
    }

    if (result is SyncConflict) {
      return _handleConflict(handler, result);
    }

    if (result is SyncFailure) {
      return _markFailure(
        result.queueItem,
        result.message,
        isRetryable: result.isRetryable,
        handler: handler,
      );
    }

    return result;
  }

  Future<SyncResult> _handleConflict(
    SyncModuleHandler handler,
    SyncConflict result,
  ) async {
    final SyncConflictResolution resolution = _conflictResolver.resolve(
      SyncConflictData(
        localPayload: result.localPayload,
        remotePayload: result.remotePayload,
      ),
    );

    if (resolution == SyncConflictResolution.acceptRemote) {
      await handler.applyRemotePayload(result.remotePayload);
      await handler.updateRecordSyncStatus(
        result.queueItem.recordId,
        SyncStatus.synced,
      );
      await _queueRepository.remove(result.queueItem.queueId);
      _debugLog.i(
        'Conflict resolved by accepting remote for ${result.queueItem.recordId}.',
      );
      return SyncSuccess(queueItem: result.queueItem);
    }

    final SyncResult retryResult = await _remoteDataSource.push(
      result.queueItem,
      result.localPayload,
    );
    if (retryResult is SyncSuccess) {
      await handler.updateRecordSyncStatus(
        result.queueItem.recordId,
        SyncStatus.synced,
      );
      await _queueRepository.remove(result.queueItem.queueId);
      return retryResult;
    }

    return _markFailure(
      result.queueItem,
      'Conflict resolved by keeping local, but remote push failed.',
      isRetryable: true,
      handler: handler,
    );
  }

  Future<SyncFailure> _markFailure(
    SyncQueueItem item,
    String message, {
    required bool isRetryable,
    SyncModuleHandler? handler,
  }) async {
    final int nextAttemptCount = item.attemptCount + 1;
    final bool exceededRetries = nextAttemptCount >= SyncConfig.maxRetryAttempts;
    final SyncQueueItemStatus nextStatus = !isRetryable || exceededRetries
        ? SyncQueueItemStatus.deadLetter
        : SyncQueueItemStatus.failed;

    if (handler != null) {
      await handler.updateRecordSyncStatus(
        item.recordId,
        SyncStatus.failed,
      );
    }

    final SyncQueueItem failedItem = item.copyWith(
      status: nextStatus,
      attemptCount: nextAttemptCount,
      updatedAt: DateTime.now(),
      lastError: message,
    );
    await _queueRepository.save(failedItem);

    _debugLog.w(
      'Sync failed for ${syncModuleDescriptor(item.module).firestoreCollection}/'
      '${item.recordId}: $message',
    );

    return SyncFailure(
      queueItem: failedItem,
      message: message,
      isRetryable: isRetryable && !exceededRetries,
    );
  }

  Future<void> _touchMeta(String key) async {
    await _hiveManager.meta.put(
      key,
      <String, dynamic>{
        key: DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
}

/// Summary of a sync engine run.
class SyncEngineReport {
  /// Creates [SyncEngineReport].
  const SyncEngineReport({
    this.succeededCount = 0,
    this.failedCount = 0,
    this.conflictCount = 0,
  });

  /// Number of queue items synced successfully.
  final int succeededCount;

  /// Number of queue items that failed during this run.
  final int failedCount;

  /// Number of queue items that hit a conflict during this run.
  final int conflictCount;

  /// Whether any queue item was processed.
  bool get hasWork =>
      succeededCount > 0 || failedCount > 0 || conflictCount > 0;
}
