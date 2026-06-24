import '../../../../utils/exports.dart';

/// Miscellaneous expense list screen.
@RoutePage()
class MiscellaneousExpensesPage extends StatelessWidget {
  /// Creates [MiscellaneousExpensesPage].
  const MiscellaneousExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return ExpenseListPage(
      config: ExpenseListUiConfig.of(
        strings,
        pageTitle: strings.miscExpensesKey,
      ),
      onAdd: () {
        unawaited(
          context.router.pushWidget(const MiscellaneousExpenseFormPage()),
        );
      },
    );
  }
}
