import '../../../../core/domain/entities/person_entity.dart';
import '../../../../core/domain/repositories/person_repository.dart';
import '../../../../service/network/response_handler.dart';

/// Persists a new person record.
class AddPersonUseCase {
  /// Creates [AddPersonUseCase].
  const AddPersonUseCase(this._repository);

  final PersonRepository _repository;

  /// Creates [person] and returns the saved record in [ResponseHandler].
  Future<ResponseHandler<PersonEntity>> call(PersonEntity person) {
    return _repository.create(person);
  }
}
