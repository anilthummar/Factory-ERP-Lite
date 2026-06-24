import '../../../../utils/exports.dart';

/// Maintenance expense list screen.
@RoutePage()
class MaintenanceExpensesPage extends StatelessWidget {
  /// Creates [MaintenanceExpensesPage].
  const MaintenanceExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return ExpenseListPage(
      config: ExpenseListUiConfig.of(
        strings,
        pageTitle: strings.maintenanceExpensesKey,
      ),
      onAdd: () {
        unawaited(
          context.router.pushWidget(const MaintenanceExpenseFormPage()),
        );
      },
    );
  }
}
