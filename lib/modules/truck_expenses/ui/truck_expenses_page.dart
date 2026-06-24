import '../../../../utils/exports.dart';
import '../../expense/foundation/expense_module_bloc.dart';
import '../../expense/foundation/expense_module_list_page.dart';
import '../bloc/truck_expense_bloc.dart';

@RoutePage()
class TruckExpensesPage extends StatelessWidget {
  const TruckExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    return BlocProvider<ExpenseModuleBloc>(
      create: (BuildContext context) => TruckExpenseBloc(
        getTruckExpensesUseCase: getIt<GetTruckExpensesUseCase>(),
        addTruckExpenseUseCase: getIt<AddTruckExpenseUseCase>(),
        updateTruckExpenseUseCase: getIt<UpdateTruckExpenseUseCase>(),
        deleteTruckExpenseUseCase: getIt<DeleteTruckExpenseUseCase>(),
        searchTruckExpensesUseCase: getIt<SearchTruckExpensesUseCase>(),
      ),
      child: ExpenseModuleListPage(
        pageTitle: strings.truckExpensesKey,
      ),
    );
  }
}
