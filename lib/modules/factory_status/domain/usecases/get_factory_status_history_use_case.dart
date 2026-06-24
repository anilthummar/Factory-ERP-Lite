import '../../../../core/domain/entities/factory_status_entity.dart';
import '../../../../core/domain/repositories/factory_status_repository.dart';

/// Returns factory status history ordered newest first.
class GetFactoryStatusHistoryUseCase {
  /// Creates [GetFactoryStatusHistoryUseCase].
  const GetFactoryStatusHistoryUseCase(this._repository);

  final FactoryStatusRepository _repository;

  /// All status history records.
  Future<List<FactoryStatusEntity>> call() => _repository.getAll();
}
