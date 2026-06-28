import '../../../../utils/exports.dart';

/// Empty state when no Records Explorer results match filters.
class ExplorerEmptyState extends StatelessWidget {
  /// Creates [ExplorerEmptyState].
  const ExplorerEmptyState({
    required this.onClearFilters,
    super.key,
  });

  /// Clears active filters.
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.padding16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.search_off_outlined,
              size: 56,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: Dimens.space16),
            CustomTextLabelWidget(
              label: strings.recordsExplorerNoRecordsKey,
              style: AppStyles.instance.textTheme.titleMedium,
            ),
            const SizedBox(height: Dimens.space16),
            FilledButton(
              onPressed: onClearFilters,
              child: Text(strings.recordsExplorerClearFiltersKey),
            ),
          ],
        ),
      ),
    );
  }
}
