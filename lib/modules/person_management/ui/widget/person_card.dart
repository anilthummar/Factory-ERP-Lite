import '../../../../core/domain/entities/person_entity.dart';
import '../../../../utils/exports.dart';

/// Display data for a person list card.
class PersonCardData {
  /// Creates [PersonCardData].
  const PersonCardData({
    required this.entity,
    required this.roleLabel,
    this.onTap,
    this.onDelete,
  });

  /// Domain entity backing this card.
  final PersonEntity entity;

  /// Unique person identifier.
  String get id => entity.id;

  /// Person display name.
  String get name => entity.name;

  /// Contact phone number.
  String get phone => entity.mobile;

  /// Secondary label shown in the trailing chip.
  final String roleLabel;

  /// Card tap callback.
  final VoidCallback? onTap;

  /// Delete action callback.
  final VoidCallback? onDelete;
}

/// Person list card built on [CustomEntityListCard].
class PersonCard extends StatelessWidget {
  /// Creates [PersonCard].
  const PersonCard({
    required this.person,
    super.key,
  });

  /// Person data to display.
  final PersonCardData person;

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;

    return CustomEntityListCard(
      leading: CircleAvatar(
        radius: Dimens.radius24,
        backgroundColor: colorScheme.primaryContainer,
        child: Icon(
          Icons.person_outline,
          color: colorScheme.onPrimaryContainer,
          size: Dimens.size28,
        ),
      ),
      title: person.name,
      subtitle: person.phone,
      onTap: person.onTap,
      trailing: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.padding10,
                vertical: Dimens.padding6,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(Dimens.radius20),
              ),
              child: CustomTextLabelWidget(
                label: person.roleLabel,
                maxLines: Dimens.maxLines01,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.instance.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
          if (person.onDelete != null)
            PopupMenuButton<_PersonCardAction>(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: Dimens.size40,
                minHeight: Dimens.size40,
              ),
              onSelected: (_PersonCardAction action) {
                switch (action) {
                  case _PersonCardAction.edit:
                    person.onTap?.call();
                  case _PersonCardAction.delete:
                    person.onDelete?.call();
                }
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<_PersonCardAction>>[
                  PopupMenuItem<_PersonCardAction>(
                    value: _PersonCardAction.edit,
                    child: Text(strings.editPersonKey),
                  ),
                  PopupMenuItem<_PersonCardAction>(
                    value: _PersonCardAction.delete,
                    child: Text(
                      strings.deletePersonKey,
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

enum _PersonCardAction {
  edit,
  delete,
}
