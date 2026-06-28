import '../../../core/domain/entities/attachment_entity.dart';
import '../../../core/sync/sync_module_type.dart';

/// Local Hive contract for attachment metadata records.
abstract class AttachmentLocalDataSource {
  /// Returns all attachment records, newest first.
  Future<List<AttachmentEntity>> getAll();

  /// Returns attachments for a parent record.
  Future<List<AttachmentEntity>> getByParent({
    required SyncModuleType parentModule,
    required String parentRecordId,
  });

  /// Returns attachments with failed sync status.
  Future<List<AttachmentEntity>> getFailed();

  /// Returns an attachment by [id], or null when not found.
  Future<AttachmentEntity?> getById(String id);

  /// Persists a new attachment record.
  Future<AttachmentEntity> add(AttachmentEntity attachment);

  /// Updates an existing attachment record.
  Future<AttachmentEntity> update(AttachmentEntity attachment);

  /// Deletes an attachment record by [id].
  Future<void> delete(String id);
}
