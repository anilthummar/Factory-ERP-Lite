import '../../../../core/domain/entities/attachment_entity.dart';
import '../../../../core/domain/repositories/attachment_repository.dart';
import '../../../../core/sync/sync_module_type.dart';

/// Loads attachment records from the repository.
class GetAttachmentsUseCase {
  /// Creates [GetAttachmentsUseCase].
  const GetAttachmentsUseCase(this._repository);

  final AttachmentRepository _repository;

  /// Returns all attachments, or parent-scoped when both params are provided.
  Future<List<AttachmentEntity>> call({
    SyncModuleType? parentModule,
    String? parentRecordId,
  }) {
    if (parentModule != null && parentRecordId != null) {
      return _repository.getByParent(
        parentModule: parentModule,
        parentRecordId: parentRecordId,
      );
    }
    return _repository.getAll();
  }
}
