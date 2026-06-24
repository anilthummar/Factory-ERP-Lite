import '../../../../core/domain/entities/dashboard_data.dart';
import '../../../../core/domain/repositories/dashboard_repository.dart';

/// Loads aggregated dashboard metrics from local Hive repositories.
class GetDashboardDataUseCase {
  /// Creates [GetDashboardDataUseCase].
  const GetDashboardDataUseCase(this._repository);

  final DashboardRepository _repository;

  /// Returns dashboard summary data.
  Future<DashboardData> call() => _repository.loadDashboardData();
}
