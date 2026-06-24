import '../../../../core/domain/entities/attachment_entity.dart';
import '../../../../core/domain/repositories/attachment_repository.dart';

/// Returns a single attachment by id.
class GetAttachmentByIdUseCase {
  /// Creates [GetAttachmentByIdUseCase].
  const GetAttachmentByIdUseCase(this._repository);

  final AttachmentRepository _repository;

  /// Loads attachment metadata for [id].
  Future<AttachmentEntity?> call(String id) => _repository.getById(id);
}
