import 'package:hive_ce/hive_ce.dart';

import '../../../core/sync/sync_queue_item.dart';
import '../../../core/sync/sync_queue_keys.dart';
import '../../hive/hive_manager.dart';
import '../sync_config.dart';
import 'sync_queue_local_data_source.dart';
import 'sync_queue_local_exception.dart';

/// Hive implementation of [SyncQueueLocalDataSource].
class SyncQueueLocalDataSourceImpl implements SyncQueueLocalDataSource {
  /// Creates [SyncQueueLocalDataSourceImpl].
  SyncQueueLocalDataSourceImpl({HiveManager? hiveManager})
      : _hiveManager = hiveManager ?? HiveManager.instance;

  final HiveManager _hiveManager;

  Box<Map<dynamic, dynamic>> get _box => _hiveManager.syncQueue;

  @override
  Future<void> enqueue(SyncQueueItem item) async {
    await _run('enqueue sync item', () async {
      await _box.put(item.queueId, item.toMap());
    });
  }

  @override
  Future<void> remove(String queueId) async {
    await _run('remove sync item', () async {
      await _box.delete(queueId);
    });
  }

  @override
  Future<List<SyncQueueItem>> getProcessableItems() async {
    return _run('load sync queue', () async {
      final List<SyncQueueItem> items = _box.values
          .map(
            (Map<dynamic, dynamic> map) =>
                SyncQueueItem.fromMap(map),
          )
          .where(_isProcessable)
          .toList(growable: false)
        ..sort(
          (SyncQueueItem a, SyncQueueItem b) =>
              a.createdAt.compareTo(b.createdAt),
        );
      return items;
    });
  }

  @override
  Future<void> update(SyncQueueItem item) async {
    await _run('update sync item', () async {
      await _box.put(item.queueId, item.toMap());
    });
  }

  @override
  Future<bool> existsForRecord({
    required String module,
    required String recordId,
  }) async {
    return _run('check sync queue', () async {
      return _box.values.any((Map<dynamic, dynamic> map) {
        return map[SyncQueueKeys.module] == module &&
            map[SyncQueueKeys.recordId] == recordId &&
            _isProcessable(SyncQueueItem.fromMap(map));
      });
    });
  }

  @override
  Future<List<SyncQueueItem>> getAllItems() async {
    return _run('load all sync queue items', () async {
      final List<SyncQueueItem> items = _box.values
          .map(
            (Map<dynamic, dynamic> map) => SyncQueueItem.fromMap(map),
          )
          .toList(growable: false)
        ..sort(
          (SyncQueueItem a, SyncQueueItem b) =>
              a.createdAt.compareTo(b.createdAt),
        );
      return items;
    });
  }

  bool _isProcessable(SyncQueueItem item) {
    if (item.status == SyncQueueItemStatus.deadLetter ||
        item.status == SyncQueueItemStatus.processing) {
      return false;
    }

    if (item.status == SyncQueueItemStatus.failed &&
        item.attemptCount >= SyncConfig.maxRetryAttempts) {
      return false;
    }

    return item.canRetry;
  }

  Future<T> _run<T>(String operation, Future<T> Function() action) async {
    if (!_hiveManager.isInitialized) {
      throw SyncQueueLocalException('Hive is not initialized. Cannot $operation.');
    }

    try {
      return await action();
    } on HiveError catch (error) {
      throw SyncQueueLocalException(
        'Hive error while trying to $operation: ${error.message}',
      );
    } on Object catch (error) {
      throw SyncQueueLocalException(
        'Unexpected error while trying to $operation: $error',
      );
    }
  }
}
