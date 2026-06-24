import '../../../../utils/exports.dart';

/// Display data for a labor list card.
class LaborCardData {
  /// Creates [LaborCardData].
  const LaborCardData({
    required this.id,
    required this.name,
    required this.phone,
    required this.skill,
    required this.dailyWage,
    this.onTap,
  });

  /// Unique labor record identifier.
  final String id;

  /// Worker display name.
  final String name;

  /// Contact phone number.
  final String phone;

  /// Worker skill or trade.
  final String skill;

  /// Daily wage display text.
  final String dailyWage;

  /// Card tap callback placeholder.
  final VoidCallback? onTap;
}

/// Labor list card built on [CustomEntityListCard].
class LaborCard extends StatelessWidget {
  /// Creates [LaborCard].
  const LaborCard({
    required this.labor,
    super.key,
  });

  /// Labor data to display.
  final LaborCardData labor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;

    return CustomEntityListCard(
      leading: CircleAvatar(
        radius: Dimens.radius24,
        backgroundColor: colorScheme.primaryContainer,
        child: Icon(
          Icons.engineering_outlined,
          color: colorScheme.onPrimaryContainer,
          size: Dimens.size28,
        ),
      ),
      title: labor.name,
      subtitle: labor.phone,
      onTap: labor.onTap,
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.padding10,
              vertical: Dimens.padding6,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(Dimens.radius20),
            ),
            child: CustomTextLabelWidget(
              label: labor.skill,
              maxLines: Dimens.maxLines01,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.instance.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: Dimens.space4),
          CustomTextLabelWidget(
            label: labor.dailyWage,
            textAlign: TextAlign.end,
            maxLines: Dimens.maxLines01,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.instance.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
