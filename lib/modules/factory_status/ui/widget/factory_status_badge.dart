import '../../../../utils/exports.dart';

/// Compact status badge chip for factory status labels.
class FactoryStatusBadge extends StatelessWidget {
  /// Creates [FactoryStatusBadge].
  const FactoryStatusBadge({
    required this.status,
    super.key,
  });

  /// Status to display.
  final FactoryStatusType status;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.padding12,
        vertical: Dimens.padding6,
      ),
      decoration: BoxDecoration(
        color: status.backgroundColor(colorScheme),
        borderRadius: BorderRadius.circular(Dimens.radius20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            status.icon,
            size: Dimens.size16,
            color: status.foregroundColor(colorScheme),
          ),
          const SizedBox(width: Dimens.space6),
          Flexible(
            child: CustomTextLabelWidget(
              label: status.label(context.appString),
              maxLines: Dimens.maxLines01,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.instance.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: status.foregroundColor(colorScheme),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
