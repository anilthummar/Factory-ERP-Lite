import '../../core/domain/sync_metadata_keys.dart';
import '../../core/enums/sync_status.dart';
import '../../core/sync/sync_module_type.dart';
import '../../utils/debug_log.dart';
import '../hive/hive_manager.dart';
import 'handlers/sync_handler_registry.dart';
import 'handlers/sync_module_handler.dart';
import 'remote/firestore_sync_pull_data_source.dart';
import 'sync_conflict_resolver.dart';
import 'sync_config.dart';
import 'sync_module_registry.dart';

/// Merges Firestore documents into Hive (inbound / pull sync).
class SyncPullEngine {
  /// Creates [SyncPullEngine].
  SyncPullEngine({
    required FirestoreSyncPullDataSource pullDataSource,
    required SyncHandlerRegistry handlerRegistry,
    HiveManager? hiveManager,
    DebugLog? debugLog,
    SyncConflictResolver? conflictResolver,
  })  : _pullDataSource = pullDataSource,
        _handlerRegistry = handlerRegistry,
        _hiveManager = hiveManager ?? HiveManager.instance,
        _debugLog = debugLog ?? DebugLog.instance,
        _conflictResolver = conflictResolver ?? const SyncConflictResolver();

  final FirestoreSyncPullDataSource _pullDataSource;
  final SyncHandlerRegistry _handlerRegistry;
  final HiveManager _hiveManager;
  final DebugLog _debugLog;
  final SyncConflictResolver _conflictResolver;

  /// Downloads all registered module collections and merges into Hive.
  ///
  /// Local records with `pending` or `failed` sync status are not overwritten.
  Future<SyncPullReport> pullAllModules() async {
    if (!_hiveManager.isInitialized) {
      return const SyncPullReport();
    }

    int appliedCount = 0;
    int skippedCount = 0;
    int errorCount = 0;

    for (final SyncModuleType module in syncModuleDescriptors.keys) {
      final SyncModuleDescriptor descriptor = syncModuleDescriptor(module);
      try {
        final List<Map<String, dynamic>> remoteRecords =
            await _pullDataSource.pullCollection(descriptor.firestoreCollection);

        for (final Map<String, dynamic> remotePayload in remoteRecords) {
          final String? recordId = remotePayload[SyncMetadataKeys.id] as String?;
          if (recordId == null || recordId.isEmpty) {
            skippedCount++;
            continue;
          }

          final bool applied = await _mergeRemoteRecord(
            module: module,
            recordId: recordId,
            remotePayload: remotePayload,
          );
          if (applied) {
            appliedCount++;
          } else {
            skippedCount++;
          }
        }
      } on Object catch (error) {
        errorCount++;
        _debugLog.w(
          'Pull failed for ${descriptor.firestoreCollection}: $error',
        );
      }
    }

    if (appliedCount > 0) {
      await _touchMeta(SyncConfig.lastRemotePullAtKey);
    }

    return SyncPullReport(
      appliedCount: appliedCount,
      skippedCount: skippedCount,
      errorCount: errorCount,
    );
  }

  Future<bool> _mergeRemoteRecord({
    required SyncModuleType module,
    required String recordId,
    required Map<String, dynamic> remotePayload,
  }) async {
    final SyncModuleHandler? handler = _handlerRegistry.handlerFor(module);
    if (handler == null) {
      return false;
    }

    final Map<String, dynamic>? localPayload =
        await handler.loadPayload(recordId);

    if (localPayload == null) {
      await handler.applyRemotePayload(remotePayload);
      await handler.updateRecordSyncStatus(recordId, SyncStatus.synced);
      return true;
    }

    final String? localStatus =
        localPayload[SyncMetadataKeys.syncStatus] as String?;
    if (localStatus == syncStatusToString(SyncStatus.pending) ||
        localStatus == syncStatusToString(SyncStatus.failed)) {
      return false;
    }

    final SyncConflictResolution resolution = _conflictResolver.resolve(
      SyncConflictData(
        localPayload: localPayload,
        remotePayload: remotePayload,
      ),
    );

    if (resolution == SyncConflictResolution.acceptRemote) {
      await handler.applyRemotePayload(remotePayload);
      await handler.updateRecordSyncStatus(recordId, SyncStatus.synced);
      return true;
    }

    return false;
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

/// Summary of a Firestore → Hive pull run.
class SyncPullReport {
  /// Creates [SyncPullReport].
  const SyncPullReport({
    this.appliedCount = 0,
    this.skippedCount = 0,
    this.errorCount = 0,
  });

  /// Records written or updated in Hive from Firestore.
  final int appliedCount;

  /// Records skipped (local pending/failed or unchanged).
  final int skippedCount;

  /// Module-level pull failures.
  final int errorCount;

  /// Whether any remote record was merged.
  bool get hasChanges => appliedCount > 0;
}
