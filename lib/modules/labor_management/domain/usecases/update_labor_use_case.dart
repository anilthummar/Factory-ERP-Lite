import '../../../../core/domain/entities/labor_entity.dart';
import '../../../../core/domain/repositories/labor_repository.dart';
import '../../../../service/network/response_handler.dart';

/// Updates an existing labor record.
class UpdateLaborUseCase {
  /// Creates [UpdateLaborUseCase].
  const UpdateLaborUseCase(this._repository);

  final LaborRepository _repository;

  /// Updates [labor] and returns the saved record in [ResponseHandler].
  Future<ResponseHandler<LaborEntity>> call(LaborEntity labor) {
    return _repository.update(labor);
  }
}
