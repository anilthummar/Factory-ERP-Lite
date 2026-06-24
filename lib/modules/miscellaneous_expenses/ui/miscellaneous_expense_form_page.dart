import '../../../../utils/exports.dart';

/// Miscellaneous expense add/edit form.
class MiscellaneousExpenseFormPage extends StatelessWidget {
  /// Creates [MiscellaneousExpenseFormPage].
  const MiscellaneousExpenseFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return ExpenseFormPage(
      config: ExpenseFormUiConfig.of(
        strings,
        pageTitleAdd: strings.miscExpensesKey,
      ),
      onSave: () => context.router.maybePop(),
    );
  }
}
