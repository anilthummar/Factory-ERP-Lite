import '../../../core/sync/sync_module_type.dart';
import '../../expense/foundation/expense_module_repository_impl.dart';
import '../datasource/maintenance_expense_local_data_source.dart';
import 'maintenance_expense_repository.dart';

/// Hive-backed [MaintenanceExpenseRepository] implementation.
class MaintenanceExpenseRepositoryImpl extends ExpenseModuleRepositoryImpl
    implements MaintenanceExpenseRepository {
  /// Creates [MaintenanceExpenseRepositoryImpl].
  MaintenanceExpenseRepositoryImpl({
    required MaintenanceExpenseLocalDataSource localDataSource,
    super.syncSupport,
  }) : super(
          localDataSource: localDataSource,
          syncModuleType: SyncModuleType.maintenanceExpenses,
        );
}
