import '../../expense/foundation/expense_module_bloc.dart';
import '../../expense/foundation/expense_module_config.dart';
import '../domain/usecases/electricity_expense_use_cases.dart';

/// BLoC for electricity expense expenses.
class ElectricityExpenseBloc extends ExpenseModuleBloc {
  ElectricityExpenseBloc({
    required GetElectricityExpensesUseCase getElectricityExpensesUseCase,
    required AddElectricityExpenseUseCase addElectricityExpenseUseCase,
    required UpdateElectricityExpenseUseCase updateElectricityExpenseUseCase,
    required DeleteElectricityExpenseUseCase deleteElectricityExpenseUseCase,
    required SearchElectricityExpensesUseCase searchElectricityExpensesUseCase,
  }) : super(
          config: ExpenseModuleConfig.electricityExpense,
          getExpensesUseCase: getElectricityExpensesUseCase,
          addExpenseUseCase: addElectricityExpenseUseCase,
          updateExpenseUseCase: updateElectricityExpenseUseCase,
          deleteExpenseUseCase: deleteElectricityExpenseUseCase,
          searchExpensesUseCase: searchElectricityExpensesUseCase,
        );
}
