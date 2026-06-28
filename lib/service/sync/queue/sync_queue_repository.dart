import '../../../core/sync/sync_module_type.dart';
import '../../../core/sync/sync_operation.dart';
import '../../../core/sync/sync_queue_item.dart';
import 'sync_queue_local_data_source.dart';

/// Repository for enqueueing and tracking offline sync queue items.
abstract class SyncQueueRepository {
  /// Adds a local mutation to the sync queue.
  Future<SyncQueueItem> enqueueMutation({
    required SyncModuleType module,
    required String recordId,
    required SyncOperation operation,
    String? factoryId,
  });

  /// Returns queue items ready for sync processing.
  Future<List<SyncQueueItem>> getProcessableItems();

  /// Persists queue item changes after a sync attempt.
  Future<void> save(SyncQueueItem item);

  /// Removes a successfully synced queue item.
  Future<void> remove(String queueId);

  /// Returns the count of queue items eligible for processing.
  Future<int> getPendingCount();

  /// Returns all items in the sync queue.
  Future<List<SyncQueueItem>> getAllItems();
}

/// Hive-backed [SyncQueueRepository] implementation.
class SyncQueueRepositoryImpl implements SyncQueueRepository {
  /// Creates [SyncQueueRepositoryImpl].
  SyncQueueRepositoryImpl({
    required SyncQueueLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  final SyncQueueLocalDataSource _localDataSource;

  @override
  Future<SyncQueueItem> enqueueMutation({
    required SyncModuleType module,
    required String recordId,
    required SyncOperation operation,
    String? factoryId,
  }) async {
    final String moduleName = syncModuleTypeToString(module);
    final bool alreadyQueued = await _localDataSource.existsForRecord(
      module: moduleName,
      recordId: recordId,
    );
    if (alreadyQueued) {
      final List<SyncQueueItem> items =
          await _localDataSource.getProcessableItems();
      return items.firstWhere(
        (SyncQueueItem item) =>
            syncModuleTypeToString(item.module) == moduleName &&
            item.recordId == recordId,
      );
    }

    final SyncQueueItem item = SyncQueueItem.forMutation(
      queueId: _buildQueueId(module, recordId),
      module: module,
      recordId: recordId,
      operation: operation,
      factoryId: factoryId,
    );
    await _localDataSource.enqueue(item);
    return item;
  }

  @override
  Future<List<SyncQueueItem>> getProcessableItems() {
    return _localDataSource.getProcessableItems();
  }

  @override
  Future<void> save(SyncQueueItem item) {
    return _localDataSource.update(item);
  }

  @override
  Future<void> remove(String queueId) {
    return _localDataSource.remove(queueId);
  }

  @override
  Future<int> getPendingCount() async {
    final List<SyncQueueItem> items = await getProcessableItems();
    return items.length;
  }

  @override
  Future<List<SyncQueueItem>> getAllItems() {
    return _localDataSource.getAllItems();
  }

  String _buildQueueId(SyncModuleType module, String recordId) {
    return '${syncModuleTypeToString(module)}::$recordId';
  }
}
