import '../../../../utils/exports.dart';
import '../../domain/entities/explorer_summary_stats.dart';

/// Top summary metric cards for Records Explorer.
class ExplorerSummaryCards extends StatelessWidget {
  /// Creates [ExplorerSummaryCards].
  const ExplorerSummaryCards({
    required this.summary,
    required this.isLoading,
    super.key,
  });

  /// Summary metrics.
  final ExplorerSummaryStats summary;

  /// Whether data is loading.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    String value(int count) => isLoading ? '—' : '$count';
    String amount(double amount) =>
        isLoading ? '—' : amount.toStringAsFixed(2);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: Dimens.space12,
      mainAxisSpacing: Dimens.space12,
      childAspectRatio: 1.5,
      children: <Widget>[
        _SummaryCard(
          title: strings.recordsExplorerTotalRecordsKey,
          value: value(summary.totalRecords),
          icon: Icons.list_alt_outlined,
        ),
        _SummaryCard(
          title: strings.recordsExplorerTotalAmountKey,
          value: amount(summary.totalAmount),
          icon: Icons.payments_outlined,
        ),
        _SummaryCard(
          title: strings.totalPersonsKey,
          value: value(summary.totalPersons),
          icon: Icons.people_outline,
        ),
        _SummaryCard(
          title: strings.totalLaborKey,
          value: value(summary.totalLabor),
          icon: Icons.engineering_outlined,
        ),
        _SummaryCard(
          title: strings.totalExpensesKey,
          value: value(summary.totalExpenses),
          icon: Icons.receipt_long_outlined,
        ),
        _SummaryCard(
          title: strings.pendingSyncKey,
          value: value(summary.pendingSyncCount),
          icon: Icons.sync_outlined,
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Card(
      elevation: Dimens.elevation0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radius12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.padding12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: colorScheme.primary, size: 22),
            const Spacer(),
            CustomTextLabelWidget(
              label: value,
              style: AppStyles.instance.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            CustomTextLabelWidget(
              label: title,
              maxLines: Dimens.maxLines02,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.instance.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
