import '../../../../core/domain/entities/labor_entity.dart';
import '../../../../core/domain/repositories/labor_repository.dart';
import '../../../../service/network/response_handler.dart';

/// Loads all labor records from the repository.
class GetLaborUseCase {
  /// Creates [GetLaborUseCase].
  const GetLaborUseCase(this._repository);

  final LaborRepository _repository;

  /// Returns all labor records wrapped in [ResponseHandler].
  Future<ResponseHandler<List<LaborEntity>>> call() {
    return _repository.getAll();
  }
}
