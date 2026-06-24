import '../../../../utils/exports.dart';

/// Highlight card showing the current factory status.
class FactoryStatusCurrentCard extends StatelessWidget {
  /// Creates [FactoryStatusCurrentCard].
  const FactoryStatusCurrentCard({
    required this.status,
    this.lastUpdated,
    super.key,
  });

  /// Current factory status.
  final FactoryStatusType status;

  /// Formatted last-updated text.
  final String? lastUpdated;

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
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
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: Dimens.radius24,
                  backgroundColor: status.backgroundColor(colorScheme),
                  child: Icon(
                    Icons.factory_outlined,
                    color: status.foregroundColor(colorScheme),
                    size: Dimens.size28,
                  ),
                ),
                const SizedBox(width: Dimens.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomTextLabelWidget(
                        label: strings.currentStatusKey,
                        textAlign: TextAlign.start,
                        style: AppStyles.instance.textTheme.labelMedium
                            ?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: Dimens.space4),
                      FactoryStatusBadge(status: status),
                    ],
                  ),
                ),
              ],
            ),
            if (lastUpdated != null && lastUpdated!.isNotEmpty) ...<Widget>[
              const SizedBox(height: Dimens.space16),
              CustomTextLabelWidget(
                label: strings.lastUpdatedKey,
                textAlign: TextAlign.start,
                style: AppStyles.instance.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Dimens.space4),
              CustomTextLabelWidget(
                label: lastUpdated!,
                textAlign: TextAlign.start,
                style: AppStyles.instance.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
