import 'dart:async';

import '../../core/sync/sync_module_type.dart';
import '../../core/sync/sync_operation.dart';
import '../../core/sync/sync_queue_item.dart';
import 'queue/sync_queue_repository.dart';
import 'sync_engine.dart';

/// Entry point for repositories to enqueue local mutations for background sync.
///
/// Repositories should call [onLocalMutation] immediately after a successful
/// Hive write while the record remains `syncStatus = pending`.
class SyncCoordinator {
  /// Creates [SyncCoordinator].
  SyncCoordinator({
    required SyncQueueRepository queueRepository,
    required SyncEngine syncEngine,
  })  : _queueRepository = queueRepository,
        _syncEngine = syncEngine;

  final SyncQueueRepository _queueRepository;
  final SyncEngine _syncEngine;

  /// Queues a local mutation and triggers a background sync attempt.
  Future<SyncQueueItem> onLocalMutation({
    required SyncModuleType module,
    required String recordId,
    required SyncOperation operation,
    String? factoryId,
    bool triggerSync = true,
  }) async {
    final SyncQueueItem item = await _queueRepository.enqueueMutation(
      module: module,
      recordId: recordId,
      operation: operation,
      factoryId: factoryId,
    );

    if (triggerSync) {
      unawaited(_syncEngine.processPending());
    }

    return item;
  }

  /// Retries all eligible failed queue items.
  Future<SyncEngineReport> retryFailed() {
    return _syncEngine.processPending();
  }
}
