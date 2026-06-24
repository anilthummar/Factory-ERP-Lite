import '../../../../utils/exports.dart';

/// Material 3 card for an ERP module on the entries grid.
class EntryModuleCard extends StatelessWidget {
  /// Creates [EntryModuleCard].
  const EntryModuleCard({
    required this.title,
    required this.icon,
    this.onTap,
    super.key,
  });

  /// Module display title.
  final String title;

  /// Module icon.
  final IconData icon;

  /// Navigation callback placeholder.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Card(
      elevation: Dimens.elevation0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radius12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.padding16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: Dimens.size40,
                color: colorScheme.primary,
              ),
              const SizedBox(height: Dimens.space12),
              CustomTextLabelWidget(
                label: title,
                maxLines: Dimens.maxLines02,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.instance.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
