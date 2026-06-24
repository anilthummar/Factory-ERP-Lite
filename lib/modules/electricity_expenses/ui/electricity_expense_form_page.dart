import '../../../../utils/exports.dart';

/// Electricity expense add/edit form.
class ElectricityExpenseFormPage extends StatelessWidget {
  /// Creates [ElectricityExpenseFormPage].
  const ElectricityExpenseFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return ExpenseFormPage(
      config: ExpenseFormUiConfig.of(
        strings,
        pageTitleAdd: strings.electricityExpensesKey,
      ),
      onSave: () => context.router.maybePop(),
    );
  }
}
