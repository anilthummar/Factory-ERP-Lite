import '../../../../utils/exports.dart';

/// Calendar event list card built on [CustomEntityListCard].
class CalendarEventCard extends StatelessWidget {
  /// Creates [CalendarEventCard].
  const CalendarEventCard({
    required this.event,
    super.key,
  });

  /// Event data to display.
  final CalendarEventData event;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;
    final Color typeColor = event.type.color(colorScheme);
    final String dateLabel = dateToString(event.date);

    return CustomEntityListCard(
      leading: CircleAvatar(
        radius: Dimens.radius24,
        backgroundColor: typeColor.withValues(alpha: 0.15),
        child: Icon(
          event.type.icon,
          color: typeColor,
          size: Dimens.size28,
        ),
      ),
      title: event.title,
      subtitle: dateLabel,
      onTap: event.onTap,
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
          label: event.type.label(context.appString),
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
