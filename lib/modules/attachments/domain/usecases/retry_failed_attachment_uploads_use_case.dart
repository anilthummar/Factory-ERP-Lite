import '../../../../core/domain/entities/attachment_entity.dart';
import '../../../../core/domain/repositories/attachment_repository.dart';
import '../../../../core/enums/sync_status.dart';
import '../../../../core/sync/sync_module_type.dart';
import '../../../../service/sync/offline_first_sync_support.dart';
import '../../../../service/sync/sync_service.dart';

/// Re-queues failed attachment uploads for background sync retry.
class RetryFailedAttachmentUploadsUseCase {
  /// Creates [RetryFailedAttachmentUploadsUseCase].
  const RetryFailedAttachmentUploadsUseCase(
    this._repository,
    this._syncSupport,
    this._syncService,
  );

  final AttachmentRepository _repository;
  final OfflineFirstSyncSupport _syncSupport;
  final SyncService _syncService;

  /// Marks failed attachments as pending and triggers sync processing.
  Future<int> call() async {
    final List<AttachmentEntity> failed = await _repository.getFailed();
    if (failed.isEmpty) {
      return 0;
    }

    for (final AttachmentEntity attachment in failed) {
      await _repository.update(
        attachment.copyWith(
          syncStatus: SyncStatus.pending,
          updatedAt: DateTime.now(),
        ),
      );
      await _syncSupport.afterUpdate(
        module: SyncModuleType.attachments,
        recordId: attachment.id,
      );
    }

    await _syncService.retryFailedSync();
    return failed.length;
  }
}
