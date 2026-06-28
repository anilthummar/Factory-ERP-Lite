import '../../../../utils/exports.dart';
import '../../domain/entities/explorer_summary_stats.dart';

/// Footer summary bar for filtered Records Explorer results.
class ExplorerBottomSummary extends StatelessWidget {
  /// Creates [ExplorerBottomSummary].
  const ExplorerBottomSummary({
    required this.summary,
    super.key,
  });

  /// Summary metrics.
  final ExplorerSummaryStats summary;

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Material(
      elevation: 8,
      color: colorScheme.surfaceContainerHighest,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.padding16,
            vertical: Dimens.padding12,
          ),
          child: Wrap(
            spacing: Dimens.space16,
            runSpacing: Dimens.space8,
            children: <Widget>[
              _Chip(
                label:
                    '${strings.recordsExplorerTotalRecordsKey}: ${summary.totalRecords}',
              ),
              _Chip(
                label:
                    '${strings.recordsExplorerTotalAmountKey}: ${summary.totalAmount.toStringAsFixed(2)}',
              ),
              _Chip(
                label:
                    '${strings.recordsExplorerAverageAmountKey}: ${summary.averageAmount.toStringAsFixed(2)}',
              ),
              _Chip(
                label:
                    '${strings.recordsExplorerHighestAmountKey}: ${summary.highestAmount.toStringAsFixed(2)}',
              ),
              _Chip(
                label:
                    '${strings.recordsExplorerLowestAmountKey}: ${summary.lowestAmount.toStringAsFixed(2)}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      visualDensity: VisualDensity.compact,
    );
  }
}
