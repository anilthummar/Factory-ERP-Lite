import '../../../../core/domain/entities/person_entity.dart';
import '../../../../core/domain/repositories/person_repository.dart';
import '../../../../service/network/response_handler.dart';

/// Searches person records by query text.
class SearchPersonsUseCase {
  /// Creates [SearchPersonsUseCase].
  const SearchPersonsUseCase(this._repository);

  final PersonRepository _repository;

  /// Returns persons matching [query] in [ResponseHandler].
  Future<ResponseHandler<List<PersonEntity>>> call(String query) {
    return _repository.search(query);
  }
}
