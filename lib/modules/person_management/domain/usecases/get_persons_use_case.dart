import '../../../../core/domain/entities/person_entity.dart';
import '../../../../core/domain/repositories/person_repository.dart';
import '../../../../service/network/response_handler.dart';

/// Loads all person records from the repository.
class GetPersonsUseCase {
  /// Creates [GetPersonsUseCase].
  const GetPersonsUseCase(this._repository);

  final PersonRepository _repository;

  /// Returns all persons wrapped in [ResponseHandler].
  Future<ResponseHandler<List<PersonEntity>>> call() {
    return _repository.getAll();
  }
}
