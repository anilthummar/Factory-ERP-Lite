import '../../expense/foundation/expense_module_config.dart';
import '../../expense/foundation/expense_module_local_data_source_impl.dart';
import '../../../service/hive/hive_manager.dart';
import 'miscellaneous_expense_local_data_source.dart';

/// Hive implementation of [MiscellaneousExpenseLocalDataSource].
class MiscellaneousExpenseLocalDataSourceImpl extends ExpenseModuleLocalDataSourceImpl
    implements MiscellaneousExpenseLocalDataSource {
  /// Creates [MiscellaneousExpenseLocalDataSourceImpl].
  MiscellaneousExpenseLocalDataSourceImpl({HiveManager? hiveManager})
      : super(
          config: ExpenseModuleConfig.miscellaneousExpense,
          hiveManager: hiveManager,
        );
}
