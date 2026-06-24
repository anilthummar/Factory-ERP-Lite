import '../../../../utils/exports.dart';
import '../../expense/foundation/expense_module_bloc.dart';
import '../../expense/foundation/expense_module_list_page.dart';
import '../bloc/electricity_expense_bloc.dart';

@RoutePage()
class ElectricityExpensesPage extends StatelessWidget {
  const ElectricityExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    return BlocProvider<ExpenseModuleBloc>(
      create: (BuildContext context) => ElectricityExpenseBloc(
        getElectricityExpensesUseCase: getIt<GetElectricityExpensesUseCase>(),
        addElectricityExpenseUseCase: getIt<AddElectricityExpenseUseCase>(),
        updateElectricityExpenseUseCase: getIt<UpdateElectricityExpenseUseCase>(),
        deleteElectricityExpenseUseCase: getIt<DeleteElectricityExpenseUseCase>(),
        searchElectricityExpensesUseCase: getIt<SearchElectricityExpensesUseCase>(),
      ),
      child: ExpenseModuleListPage(
        pageTitle: strings.electricityExpensesKey,
      ),
    );
  }
}
