import '../../sync/sync_module_type.dart';
import '../entities/attachment_entity.dart';

/// Contract for attachment metadata and file persistence.
abstract class AttachmentRepository {
  /// Persists a new attachment record locally.
  Future<AttachmentEntity> create(AttachmentEntity attachment);

  /// Returns an attachment by [id], or null when missing.
  Future<AttachmentEntity?> getById(String id);

  /// Returns all attachment records.
  Future<List<AttachmentEntity>> getAll();

  /// Returns attachments linked to a parent record.
  Future<List<AttachmentEntity>> getByParent({
    required SyncModuleType parentModule,
    required String parentRecordId,
  });

  /// Returns attachments with failed sync/upload status.
  Future<List<AttachmentEntity>> getFailed();

  /// Updates an existing attachment record.
  Future<AttachmentEntity> update(AttachmentEntity attachment);

  /// Deletes an attachment record and local file copy.
  Future<void> delete(String id);
}
