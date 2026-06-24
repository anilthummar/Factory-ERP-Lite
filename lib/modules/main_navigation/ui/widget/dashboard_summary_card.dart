import '../../../../utils/exports.dart';

/// Summary metric card for the dashboard overview.
class DashboardSummaryCard extends StatelessWidget {
  /// Creates [DashboardSummaryCard].
  const DashboardSummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    this.compactValue = false,
    super.key,
  });

  /// Metric label.
  final String title;

  /// Metric value.
  final String value;

  /// Metric icon.
  final IconData icon;

  /// Uses a smaller value style for longer text such as timestamps.
  final bool compactValue;

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
        padding: const EdgeInsets.all(Dimens.padding16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              icon,
              color: colorScheme.primary,
              size: Dimens.size28,
            ),
            const SizedBox(height: Dimens.space12),
            CustomTextLabelWidget(
              label: value,
              textAlign: TextAlign.start,
              maxLines: compactValue ? Dimens.maxLines02 : Dimens.maxLines01,
              overflow: TextOverflow.ellipsis,
              style: (compactValue
                      ? AppStyles.instance.textTheme.titleSmall
                      : AppStyles.instance.textTheme.headlineSmall)
                  ?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: Dimens.space4),
            CustomTextLabelWidget(
              label: title,
              textAlign: TextAlign.start,
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
