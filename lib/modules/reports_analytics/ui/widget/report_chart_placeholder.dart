import '../../../../utils/exports.dart';

/// Chart visualization placeholder for report screens.
class ReportChartPlaceholder extends StatelessWidget {
  /// Creates [ReportChartPlaceholder].
  const ReportChartPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Card(
      elevation: Dimens.elevation0,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radius12),
      ),
      child: SizedBox(
        height: Dimens.size200,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.bar_chart_outlined,
              size: Dimens.size48,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: Dimens.space12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.padding16),
              child: CustomTextLabelWidget(
                label: strings.reportChartPlaceholderKey,
                style: AppStyles.instance.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
