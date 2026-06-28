import '../../expense/foundation/expense_module_bloc.dart';
import '../../expense/foundation/expense_module_config.dart';
import '../domain/usecases/miscellaneous_expense_use_cases.dart';

/// BLoC for miscellaneous expense expenses.
class MiscellaneousExpenseBloc extends ExpenseModuleBloc {
  MiscellaneousExpenseBloc({
    required GetMiscellaneousExpensesUseCase getMiscellaneousExpensesUseCase,
    required AddMiscellaneousExpenseUseCase addMiscellaneousExpenseUseCase,
    required UpdateMiscellaneousExpenseUseCase updateMiscellaneousExpenseUseCase,
    required DeleteMiscellaneousExpenseUseCase deleteMiscellaneousExpenseUseCase,
    required SearchMiscellaneousExpensesUseCase searchMiscellaneousExpensesUseCase,
  }) : super(
          config: ExpenseModuleConfig.miscellaneousExpense,
          getExpensesUseCase: getMiscellaneousExpensesUseCase,
          addExpenseUseCase: addMiscellaneousExpenseUseCase,
          updateExpenseUseCase: updateMiscellaneousExpenseUseCase,
          deleteExpenseUseCase: deleteMiscellaneousExpenseUseCase,
          searchExpensesUseCase: searchMiscellaneousExpensesUseCase,
        );
}
