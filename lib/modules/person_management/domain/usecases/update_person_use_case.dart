import '../../../../core/domain/entities/person_entity.dart';
import '../../../../core/domain/repositories/person_repository.dart';
import '../../../../service/network/response_handler.dart';

/// Updates an existing person record.
class UpdatePersonUseCase {
  /// Creates [UpdatePersonUseCase].
  const UpdatePersonUseCase(this._repository);

  final PersonRepository _repository;

  /// Updates [person] and returns the saved record in [ResponseHandler].
  Future<ResponseHandler<PersonEntity>> call(PersonEntity person) {
    return _repository.update(person);
  }
}
