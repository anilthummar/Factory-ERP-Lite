import '../../../core/sync/sync_module_type.dart';
import '../../expense/foundation/expense_module_repository_impl.dart';
import '../datasource/electricity_expense_local_data_source.dart';
import 'electricity_expense_repository.dart';

/// Hive-backed [ElectricityExpenseRepository] implementation.
class ElectricityExpenseRepositoryImpl extends ExpenseModuleRepositoryImpl
    implements ElectricityExpenseRepository {
  /// Creates [ElectricityExpenseRepositoryImpl].
  ElectricityExpenseRepositoryImpl({
    required ElectricityExpenseLocalDataSource localDataSource,
    super.syncSupport,
  }) : super(
          localDataSource: localDataSource,
          syncModuleType: SyncModuleType.electricityExpenses,
        );
}
