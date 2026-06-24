import '../../expense/foundation/expense_module_bloc.dart';
import '../../expense/foundation/expense_module_config.dart';
import '../domain/usecases/truck_expense_use_cases.dart';

/// BLoC for truck expense expenses.
class TruckExpenseBloc extends ExpenseModuleBloc {
  TruckExpenseBloc({
    required GetTruckExpensesUseCase getTruckExpensesUseCase,
    required AddTruckExpenseUseCase addTruckExpenseUseCase,
    required UpdateTruckExpenseUseCase updateTruckExpenseUseCase,
    required DeleteTruckExpenseUseCase deleteTruckExpenseUseCase,
    required SearchTruckExpensesUseCase searchTruckExpensesUseCase,
  }) : super(
          config: ExpenseModuleConfig.truckExpense,
          getExpensesUseCase: getTruckExpensesUseCase,
          addExpenseUseCase: addTruckExpenseUseCase,
          updateExpenseUseCase: updateTruckExpenseUseCase,
          deleteExpenseUseCase: deleteTruckExpenseUseCase,
          searchExpensesUseCase: searchTruckExpensesUseCase,
        );
}
