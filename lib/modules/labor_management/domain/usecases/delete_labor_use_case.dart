import '../../../../core/domain/repositories/labor_repository.dart';
import '../../../../service/network/response_handler.dart';

/// Deletes a labor record by identifier.
class DeleteLaborUseCase {
  /// Creates [DeleteLaborUseCase].
  const DeleteLaborUseCase(this._repository);

  final LaborRepository _repository;

  /// Deletes the labor record with [id].
  Future<ResponseHandler<void>> call(String id) {
    return _repository.delete(id);
  }
}
