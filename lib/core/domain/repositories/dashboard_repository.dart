import '../entities/dashboard_data.dart';

/// Contract for aggregating dashboard metrics from local repositories.
abstract class DashboardRepository {
  /// Loads dashboard summary metrics and recent activity from Hive.
  Future<DashboardData> loadDashboardData();
}
