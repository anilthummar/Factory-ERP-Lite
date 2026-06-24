import '../../expense/foundation/expense_module_config.dart';
import '../../expense/foundation/expense_module_local_data_source_impl.dart';
import 'electricity_expense_local_data_source.dart';

/// Hive implementation of [ElectricityExpenseLocalDataSource].
class ElectricityExpenseLocalDataSourceImpl extends ExpenseModuleLocalDataSourceImpl
    implements ElectricityExpenseLocalDataSource {
  /// Creates [ElectricityExpenseLocalDataSourceImpl].
  ElectricityExpenseLocalDataSourceImpl({super.hiveManager})
      : super(
          config: ExpenseModuleConfig.electricityExpense,
        );
}
