import '../../../../utils/exports.dart';

/// Display data for a person list card.
class PersonCardData {
  /// Creates [PersonCardData].
  const PersonCardData({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    this.onTap,
  });

  /// Unique person identifier.
  final String id;

  /// Person display name.
  final String name;

  /// Contact phone number.
  final String phone;

  /// Person role or designation.
  final String role;

  /// Card tap callback placeholder.
  final VoidCallback? onTap;
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
      trailing: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.padding10,
          vertical: Dimens.padding6,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(Dimens.radius20),
        ),
        child: CustomTextLabelWidget(
          label: person.role,
          maxLines: Dimens.maxLines01,
          overflow: TextOverflow.ellipsis,
          style: AppStyles.instance.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
