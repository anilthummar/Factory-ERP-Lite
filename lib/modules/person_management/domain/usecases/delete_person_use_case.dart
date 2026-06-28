import '../../../../core/domain/repositories/person_repository.dart';
import '../../../../service/network/response_handler.dart';

/// Deletes a person record by id.
class DeletePersonUseCase {
  /// Creates [DeletePersonUseCase].
  const DeletePersonUseCase(this._repository);

  final PersonRepository _repository;

  /// Deletes the person with [id].
  Future<ResponseHandler<void>> call(String id) {
    return _repository.delete(id);
  }
}
