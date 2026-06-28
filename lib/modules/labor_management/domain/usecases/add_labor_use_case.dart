import '../../../../core/domain/entities/labor_entity.dart';
import '../../../../core/domain/repositories/labor_repository.dart';
import '../../../../service/network/response_handler.dart';

/// Persists a new labor record.
class AddLaborUseCase {
  /// Creates [AddLaborUseCase].
  const AddLaborUseCase(this._repository);

  final LaborRepository _repository;

  /// Creates [labor] and returns the saved record in [ResponseHandler].
  Future<ResponseHandler<LaborEntity>> call(LaborEntity labor) {
    return _repository.create(labor);
  }
}
