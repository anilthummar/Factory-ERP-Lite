import '../../../core/sync/sync_module_type.dart';
import '../../expense/foundation/expense_module_repository_impl.dart';
import '../datasource/miscellaneous_expense_local_data_source.dart';
import 'miscellaneous_expense_repository.dart';

/// Hive-backed [MiscellaneousExpenseRepository] implementation.
class MiscellaneousExpenseRepositoryImpl extends ExpenseModuleRepositoryImpl
    implements MiscellaneousExpenseRepository {
  /// Creates [MiscellaneousExpenseRepositoryImpl].
  MiscellaneousExpenseRepositoryImpl({
    required MiscellaneousExpenseLocalDataSource localDataSource,
    super.syncSupport,
  }) : super(
          localDataSource: localDataSource,
          syncModuleType: SyncModuleType.miscellaneousExpenses,
        );
}
