import '../../../core/sync/sync_queue_item.dart';

/// Local Hive contract for the sync queue box.
abstract class SyncQueueLocalDataSource {
  /// Persists [item] in the sync queue.
  Future<void> enqueue(SyncQueueItem item);

  /// Removes a processed queue item by [queueId].
  Future<void> remove(String queueId);

  /// Returns queue items eligible for processing.
  Future<List<SyncQueueItem>> getProcessableItems();

  /// Updates an existing queue item.
  Future<void> update(SyncQueueItem item);

  /// Returns whether a queue item already exists for [module] + [recordId].
  Future<bool> existsForRecord({
    required String module,
    required String recordId,
  });

  /// Returns every item currently stored in the sync queue.
  Future<List<SyncQueueItem>> getAllItems();
}
