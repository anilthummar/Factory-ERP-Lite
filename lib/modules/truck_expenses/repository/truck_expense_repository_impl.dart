import '../../../core/sync/sync_module_type.dart';
import '../../expense/foundation/expense_module_repository_impl.dart';
import '../datasource/truck_expense_local_data_source.dart';
import 'truck_expense_repository.dart';

/// Hive-backed [TruckExpenseRepository] implementation.
class TruckExpenseRepositoryImpl extends ExpenseModuleRepositoryImpl
    implements TruckExpenseRepository {
  /// Creates [TruckExpenseRepositoryImpl].
  TruckExpenseRepositoryImpl({
    required TruckExpenseLocalDataSource localDataSource,
    super.syncSupport,
  }) : super(
          localDataSource: localDataSource,
          syncModuleType: SyncModuleType.truckExpenses,
        );
}
