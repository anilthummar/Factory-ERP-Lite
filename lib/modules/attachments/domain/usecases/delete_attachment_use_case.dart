import '../../../../core/domain/repositories/attachment_repository.dart';

/// Deletes an attachment record and its local file copy.
class DeleteAttachmentUseCase {
  /// Creates [DeleteAttachmentUseCase].
  const DeleteAttachmentUseCase(this._repository);

  final AttachmentRepository _repository;

  /// Removes attachment [id] locally and enqueues remote delete.
  Future<void> call(String id) => _repository.delete(id);
}
