import '../../../../core/domain/entities/labor_entity.dart';
import '../../../../core/domain/repositories/labor_repository.dart';
import '../../../../service/network/response_handler.dart';

/// Searches labor records by query text.
class SearchLaborUseCase {
  /// Creates [SearchLaborUseCase].
  const SearchLaborUseCase(this._repository);

  final LaborRepository _repository;

  /// Returns labor records matching [query] wrapped in [ResponseHandler].
  Future<ResponseHandler<List<LaborEntity>>> call(String query) {
    return _repository.search(query);
  }
}
