import '../../../../utils/exports.dart';

/// Display data for an expense list card.
class ExpenseCardData {
  /// Creates [ExpenseCardData].
  const ExpenseCardData({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.onTap,
  });

  /// Unique expense identifier.
  final String id;

  /// Expense title.
  final String title;

  /// Formatted amount text.
  final String amount;

  /// Formatted date text.
  final String date;

  /// Card tap callback placeholder.
  final VoidCallback? onTap;
}

/// Material 3 expense list card built on [CustomEntityListCard].
class ExpenseCard extends StatelessWidget {
  /// Creates [ExpenseCard].
  const ExpenseCard({
    required this.expense,
    super.key,
  });

  /// Expense data to display.
  final ExpenseCardData expense;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;

    return CustomEntityListCard(
      leading: CircleAvatar(
        radius: Dimens.radius24,
        backgroundColor: colorScheme.primaryContainer,
        child: Icon(
          Icons.receipt_long_outlined,
          color: colorScheme.onPrimaryContainer,
          size: Dimens.size28,
        ),
      ),
      title: expense.title,
      subtitle: expense.date,
      onTap: expense.onTap,
      trailing: CustomTextLabelWidget(
        label: expense.amount,
        textAlign: TextAlign.end,
        maxLines: Dimens.maxLines01,
        overflow: TextOverflow.ellipsis,
        style: AppStyles.instance.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}
