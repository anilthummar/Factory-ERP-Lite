import '../../expense/foundation/expense_module_config.dart';
import '../../expense/foundation/expense_module_local_data_source_impl.dart';
import '../../../service/hive/hive_manager.dart';
import 'truck_expense_local_data_source.dart';

/// Hive implementation of [TruckExpenseLocalDataSource].
class TruckExpenseLocalDataSourceImpl extends ExpenseModuleLocalDataSourceImpl
    implements TruckExpenseLocalDataSource {
  /// Creates [TruckExpenseLocalDataSourceImpl].
  TruckExpenseLocalDataSourceImpl({HiveManager? hiveManager})
      : super(
          config: ExpenseModuleConfig.truckExpense,
          hiveManager: hiveManager,
        );
}
