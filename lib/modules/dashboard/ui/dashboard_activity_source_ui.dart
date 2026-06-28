import '../../../app/translations/app_string/app_string.dart';
import '../../../core/domain/entities/dashboard_activity_item.dart';

/// Localized module labels for [DashboardActivitySource].
extension DashboardActivitySourceUi on DashboardActivitySource {
  /// Returns a user-facing module label for recent activity rows.
  String label(AppString strings) {
    switch (this) {
      case DashboardActivitySource.person:
        return strings.personManagementKey;
      case DashboardActivitySource.labor:
        return strings.laborManagementKey;
      case DashboardActivitySource.expense:
        return strings.dashboardActivityExpenseKey;
      case DashboardActivitySource.recurringExpense:
        return strings.recurringExpensesKey;
      case DashboardActivitySource.factoryStatus:
        return strings.factoryStatusKey;
    }
  }
}
