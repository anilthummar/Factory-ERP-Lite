import '../../../../utils/exports.dart';

/// Display data for a recurring expense list card.
class RecurringExpenseCardData {
  /// Creates [RecurringExpenseCardData].
  const RecurringExpenseCardData({
    required this.id,
    required this.title,
    required this.amount,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.onTap,
  });

  /// Unique recurring expense identifier.
  final String id;

  /// Expense title.
  final String title;

  /// Formatted amount text.
  final String amount;

  /// Localized frequency label.
  final String frequency;

  /// Formatted start date text.
  final String startDate;

  /// Formatted end date text when set.
  final String? endDate;

  /// Card tap callback placeholder.
  final VoidCallback? onTap;
}

/// Recurring expense list card built on [CustomEntityListCard].
class RecurringExpenseCard extends StatelessWidget {
  /// Creates [RecurringExpenseCard].
  const RecurringExpenseCard({
    required this.expense,
    super.key,
  });

  /// Recurring expense data to display.
  final RecurringExpenseCardData expense;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;
    final String subtitle = expense.endDate == null
        ? '${expense.frequency} · ${expense.startDate}'
        : '${expense.frequency} · ${expense.startDate} – ${expense.endDate}';

    return CustomEntityListCard(
      leading: CircleAvatar(
        radius: Dimens.radius24,
        backgroundColor: colorScheme.primaryContainer,
        child: Icon(
          Icons.autorenew,
          color: colorScheme.onPrimaryContainer,
          size: Dimens.size28,
        ),
      ),
      title: expense.title,
      subtitle: subtitle,
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
