import '../../../../utils/exports.dart';

/// Material 3 list row card with leading, title, subtitle, and trailing.
class CustomEntityListCard extends StatelessWidget {
  /// Creates [CustomEntityListCard].
  const CustomEntityListCard({
    required this.leading,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    super.key,
  });

  /// Leading widget (avatar, icon, etc.).
  final Widget leading;

  /// Primary title text.
  final String title;

  /// Secondary subtitle text.
  final String subtitle;

  /// Optional trailing widget (badge, action, etc.).
  final Widget? trailing;

  /// Tap callback.
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
          child: Row(
            children: <Widget>[
              leading,
              const SizedBox(width: Dimens.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomTextLabelWidget(
                      label: title,
                      textAlign: TextAlign.start,
                      maxLines: Dimens.maxLines01,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.instance.textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: Dimens.space4),
                    CustomTextLabelWidget(
                      label: subtitle,
                      textAlign: TextAlign.start,
                      maxLines: Dimens.maxLines01,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.instance.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...<Widget>[
                const SizedBox(width: Dimens.space8),
                Flexible(
                  child: LayoutBuilder(
                    builder: (
                      BuildContext context,
                      BoxConstraints constraints,
                    ) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth,
                          ),
                          child: trailing!,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
