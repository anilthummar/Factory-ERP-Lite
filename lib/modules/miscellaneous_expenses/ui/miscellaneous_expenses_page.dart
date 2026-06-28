import '../../../../utils/exports.dart';
import '../../expense/foundation/expense_module_bloc.dart';
import '../../expense/foundation/expense_module_list_page.dart';
import '../bloc/miscellaneous_expense_bloc.dart';

@RoutePage()
class MiscellaneousExpensesPage extends StatelessWidget {
  const MiscellaneousExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    return BlocProvider<ExpenseModuleBloc>(
      create: (BuildContext context) => MiscellaneousExpenseBloc(
        getMiscellaneousExpensesUseCase: getIt<GetMiscellaneousExpensesUseCase>(),
        addMiscellaneousExpenseUseCase: getIt<AddMiscellaneousExpenseUseCase>(),
        updateMiscellaneousExpenseUseCase: getIt<UpdateMiscellaneousExpenseUseCase>(),
        deleteMiscellaneousExpenseUseCase: getIt<DeleteMiscellaneousExpenseUseCase>(),
        searchMiscellaneousExpensesUseCase: getIt<SearchMiscellaneousExpensesUseCase>(),
      ),
      child: ExpenseModuleListPage(
        pageTitle: strings.miscExpensesKey,
      ),
    );
  }
}
