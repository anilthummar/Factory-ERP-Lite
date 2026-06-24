import '../../../../utils/exports.dart';

/// Centered empty state with icon, title, and message.
class CustomEmptyStateWidget extends StatelessWidget {
  /// Creates [CustomEmptyStateWidget].
  const CustomEmptyStateWidget({
    required this.icon,
    required this.title,
    required this.message,
    this.iconSize = Dimens.size72,
    super.key,
  });

  /// Empty state icon.
  final IconData icon;

  /// Primary empty state title.
  final String title;

  /// Supporting empty state message.
  final String message;

  /// Icon size.
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.space24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: iconSize,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: Dimens.space16),
            CustomTextLabelWidget(
              label: title,
              style: AppStyles.instance.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: Dimens.space8),
            CustomTextLabelWidget(
              label: message,
              style: AppStyles.instance.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
