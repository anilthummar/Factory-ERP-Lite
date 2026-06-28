import '../../expense/foundation/expense_module_config.dart';
import '../../expense/foundation/expense_module_local_data_source_impl.dart';
import '../../../service/hive/hive_manager.dart';
import 'maintenance_expense_local_data_source.dart';

/// Hive implementation of [MaintenanceExpenseLocalDataSource].
class MaintenanceExpenseLocalDataSourceImpl extends ExpenseModuleLocalDataSourceImpl
    implements MaintenanceExpenseLocalDataSource {
  /// Creates [MaintenanceExpenseLocalDataSourceImpl].
  MaintenanceExpenseLocalDataSourceImpl({HiveManager? hiveManager})
      : super(
          config: ExpenseModuleConfig.maintenanceExpense,
          hiveManager: hiveManager,
        );
}
