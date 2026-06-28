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
    this.onDelete,
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

  /// Delete action callback.
  final VoidCallback? onDelete;
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
    final AppString strings = context.appString;
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
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
          if (labor.onDelete != null)
            PopupMenuButton<_LaborCardAction>(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: Dimens.size40,
                minHeight: Dimens.size40,
              ),
              onSelected: (_LaborCardAction action) {
                switch (action) {
                  case _LaborCardAction.edit:
                    labor.onTap?.call();
                  case _LaborCardAction.delete:
                    labor.onDelete?.call();
                }
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<_LaborCardAction>>[
                  PopupMenuItem<_LaborCardAction>(
                    value: _LaborCardAction.edit,
                    child: Text(strings.editLaborKey),
                  ),
                  PopupMenuItem<_LaborCardAction>(
                    value: _LaborCardAction.delete,
                    child: Text(
                      strings.deleteLaborKey,
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                ];
              },
            ),
        ],
      ),
    );
  }
}

enum _LaborCardAction {
  edit,
  delete,
}
