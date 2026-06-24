import '../../expense/foundation/expense_module_bloc.dart';
import '../../expense/foundation/expense_module_config.dart';
import '../domain/usecases/maintenance_expense_use_cases.dart';

/// BLoC for maintenance expense expenses.
class MaintenanceExpenseBloc extends ExpenseModuleBloc {
  MaintenanceExpenseBloc({
    required GetMaintenanceExpensesUseCase getMaintenanceExpensesUseCase,
    required AddMaintenanceExpenseUseCase addMaintenanceExpenseUseCase,
    required UpdateMaintenanceExpenseUseCase updateMaintenanceExpenseUseCase,
    required DeleteMaintenanceExpenseUseCase deleteMaintenanceExpenseUseCase,
    required SearchMaintenanceExpensesUseCase searchMaintenanceExpensesUseCase,
  }) : super(
          config: ExpenseModuleConfig.maintenanceExpense,
          getExpensesUseCase: getMaintenanceExpensesUseCase,
          addExpenseUseCase: addMaintenanceExpenseUseCase,
          updateExpenseUseCase: updateMaintenanceExpenseUseCase,
          deleteExpenseUseCase: deleteMaintenanceExpenseUseCase,
          searchExpensesUseCase: searchMaintenanceExpensesUseCase,
        );
}
