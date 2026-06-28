import '../../../../utils/exports.dart';

/// Truck expense add/edit form.
class TruckExpenseFormPage extends StatelessWidget {
  /// Creates [TruckExpenseFormPage].
  const TruckExpenseFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return ExpenseFormPage(
      config: ExpenseFormUiConfig.of(
        strings,
        pageTitleAdd: strings.truckExpensesKey,
      ),
      onSave: () => context.router.maybePop(),
    );
  }
}
