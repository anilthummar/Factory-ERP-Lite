import '../../../../core/domain/entities/factory_status_entity.dart';
import '../../../../core/domain/repositories/factory_status_repository.dart';

/// Returns the latest factory status from local Hive history.
class GetCurrentFactoryStatusUseCase {
  /// Creates [GetCurrentFactoryStatusUseCase].
  const GetCurrentFactoryStatusUseCase(this._repository);

  final FactoryStatusRepository _repository;

  /// Latest status entry, or null when history is empty.
  Future<FactoryStatusEntity?> call() => _repository.getCurrent();
}
