import '../../../../utils/exports.dart';

/// Electricity expense list screen.
@RoutePage()
class ElectricityExpensesPage extends StatelessWidget {
  /// Creates [ElectricityExpensesPage].
  const ElectricityExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return ExpenseListPage(
      config: ExpenseListUiConfig.of(
        strings,
        pageTitle: strings.electricityExpensesKey,
      ),
      onAdd: () {
        unawaited(
          context.router.pushWidget(const ElectricityExpenseFormPage()),
        );
      },
    );
  }
}
