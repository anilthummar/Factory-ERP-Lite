import '../../../../utils/exports.dart';
import '../../expense/foundation/expense_module_bloc.dart';
import '../../expense/foundation/expense_module_list_page.dart';
import '../bloc/maintenance_expense_bloc.dart';

@RoutePage()
class MaintenanceExpensesPage extends StatelessWidget {
  const MaintenanceExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    return BlocProvider<ExpenseModuleBloc>(
      create: (BuildContext context) => MaintenanceExpenseBloc(
        getMaintenanceExpensesUseCase: getIt<GetMaintenanceExpensesUseCase>(),
        addMaintenanceExpenseUseCase: getIt<AddMaintenanceExpenseUseCase>(),
        updateMaintenanceExpenseUseCase: getIt<UpdateMaintenanceExpenseUseCase>(),
        deleteMaintenanceExpenseUseCase: getIt<DeleteMaintenanceExpenseUseCase>(),
        searchMaintenanceExpensesUseCase: getIt<SearchMaintenanceExpensesUseCase>(),
      ),
      child: ExpenseModuleListPage(
        pageTitle: strings.maintenanceExpensesKey,
      ),
    );
  }
}
