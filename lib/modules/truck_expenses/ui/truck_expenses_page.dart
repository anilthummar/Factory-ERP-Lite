import '../../../../utils/exports.dart';

/// Truck expense list screen.
@RoutePage()
class TruckExpensesPage extends StatelessWidget {
  /// Creates [TruckExpensesPage].
  const TruckExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return ExpenseListPage(
      config: ExpenseListUiConfig.of(
        strings,
        pageTitle: strings.truckExpensesKey,
      ),
      onAdd: () {
        unawaited(
          context.router.pushWidget(const TruckExpenseFormPage()),
        );
      },
    );
  }
}
