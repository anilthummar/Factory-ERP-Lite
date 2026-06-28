import '../../../../utils/exports.dart';

/// Recurring expense list with pull-to-refresh and empty state.
class RecurringExpenseListView extends StatelessWidget {
  /// Creates [RecurringExpenseListView].
  const RecurringExpenseListView({
    required this.expenses,
    required this.onRefresh,
    super.key,
  });

  /// Recurring expense records to display.
  final List<RecurringExpenseCardData> expenses;

  /// Pull-to-refresh placeholder callback.
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return CustomRefreshableListView(
      isEmpty: expenses.isEmpty,
      onRefresh: onRefresh,
      emptyView: ExpenseEmptyView(
        config: ExpenseEmptyUiConfig(
          icon: Icons.autorenew,
          title: strings.recurringExpenseEmptyTitleKey,
          message: strings.recurringExpenseEmptyMessageKey,
        ),
      ),
      itemCount: expenses.length,
      itemBuilder: (BuildContext context, int index) {
        return RecurringExpenseCard(expense: expenses[index]);
      },
    );
  }
}
