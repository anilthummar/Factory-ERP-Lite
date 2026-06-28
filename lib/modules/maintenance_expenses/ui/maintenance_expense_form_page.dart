import '../../../../utils/exports.dart';

/// Maintenance expense add/edit form.
class MaintenanceExpenseFormPage extends StatelessWidget {
  /// Creates [MaintenanceExpenseFormPage].
  const MaintenanceExpenseFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return ExpenseFormPage(
      config: ExpenseFormUiConfig.of(
        strings,
        pageTitleAdd: strings.maintenanceExpensesKey,
      ),
      onSave: () => context.router.maybePop(),
    );
  }
}
