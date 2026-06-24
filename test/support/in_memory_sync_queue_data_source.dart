import 'package:factory_erp_lite/core/sync/sync_queue_item.dart';
import 'package:factory_erp_lite/service/sync/queue/sync_queue_local_data_source.dart';

/// In-memory sync queue used by integration tests.
class InMemorySyncQueueLocalDataSource implements SyncQueueLocalDataSource {
  final Map<String, SyncQueueItem> _items = <String, SyncQueueItem>{};

  @override
  Future<void> enqueue(SyncQueueItem item) async {
    _items[item.queueId] = item;
  }

  @override
  Future<void> remove(String queueId) async {
    _items.remove(queueId);
  }

  @override
  Future<List<SyncQueueItem>> getProcessableItems() async {
    final List<SyncQueueItem> items = _items.values
        .where((SyncQueueItem item) => item.canRetry)
        .toList(growable: false)
      ..sort(
        (SyncQueueItem a, SyncQueueItem b) =>
            a.createdAt.compareTo(b.createdAt),
      );
    return items;
  }

  @override
  Future<void> update(SyncQueueItem item) async {
    _items[item.queueId] = item;
  }

  @override
  Future<bool> existsForRecord({
    required String module,
    required String recordId,
  }) async {
    return _items.values.any(
      (SyncQueueItem item) =>
          item.module.name == module &&
          item.recordId == recordId &&
          item.canRetry,
    );
  }

  @override
  Future<List<SyncQueueItem>> getAllItems() async {
    return _items.values.toList(growable: false);
  }
}
