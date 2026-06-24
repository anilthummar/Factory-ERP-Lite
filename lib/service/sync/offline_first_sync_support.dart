import '../../core/sync/sync_module_type.dart';
import '../../core/sync/sync_operation.dart';
import 'sync_coordinator.dart';

/// Shared helper for enqueueing Hive mutations into the sync pipeline.
class OfflineFirstSyncSupport {
  /// Creates [OfflineFirstSyncSupport].
  const OfflineFirstSyncSupport(this._coordinator);

  final SyncCoordinator? _coordinator;

  /// Enqueues a create mutation after a successful local write.
  Future<void> afterCreate({
    required SyncModuleType module,
    required String recordId,
  }) {
    return _enqueue(
      module: module,
      recordId: recordId,
      operation: SyncOperation.create,
    );
  }

  /// Enqueues an update mutation after a successful local write.
  Future<void> afterUpdate({
    required SyncModuleType module,
    required String recordId,
  }) {
    return _enqueue(
      module: module,
      recordId: recordId,
      operation: SyncOperation.update,
    );
  }

  /// Enqueues a delete mutation after a successful local write.
  Future<void> afterDelete({
    required SyncModuleType module,
    required String recordId,
  }) {
    return _enqueue(
      module: module,
      recordId: recordId,
      operation: SyncOperation.delete,
    );
  }

  Future<void> _enqueue({
    required SyncModuleType module,
    required String recordId,
    required SyncOperation operation,
  }) async {
    final SyncCoordinator? coordinator = _coordinator;
    if (coordinator == null) {
      return;
    }

    await coordinator.onLocalMutation(
      module: module,
      recordId: recordId,
      operation: operation,
    );
  }
}
