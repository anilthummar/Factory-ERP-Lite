import '../../../../utils/exports.dart';

/// Chronological event list for the focused month.
class CalendarAgendaView extends StatelessWidget {
  /// Creates [CalendarAgendaView].
  const CalendarAgendaView({
    required this.focusedMonth,
    required this.events,
    required this.selectedDate,
    required this.onDateSelected,
    super.key,
  });

  /// Month whose events are listed.
  final DateTime focusedMonth;

  /// All calendar events.
  final List<CalendarEventData> events;

  /// Currently selected date for highlight.
  final DateTime selectedDate;

  /// Called when an agenda date header is tapped.
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final List<CalendarEventData> monthEvents =
        calendarEventsForMonth(events, focusedMonth);

    if (monthEvents.isEmpty) {
      return const CalendarAgendaEmptyView();
    }

    final Map<DateTime, List<CalendarEventData>> groupedEvents =
        <DateTime, List<CalendarEventData>>{};
    for (final CalendarEventData event in monthEvents) {
      final DateTime key = calendarDateOnly(event.date);
      groupedEvents.putIfAbsent(key, () => <CalendarEventData>[]).add(event);
    }

    final List<DateTime> sortedDates = groupedEvents.keys.toList()..sort();

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.padding16),
      itemCount: sortedDates.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: Dimens.space8),
      itemBuilder: (BuildContext context, int index) {
        final DateTime date = sortedDates[index];
        final List<CalendarEventData> dayEvents = groupedEvents[date]!;
        final bool isSelected = calendarIsSameDay(date, selectedDate);
        final String dateLabel = dateToString(date);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Material(
              color: isSelected
                  ? context.theme.colorScheme.primaryContainer
                  : context.theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(Dimens.radius8),
              child: InkWell(
                borderRadius: BorderRadius.circular(Dimens.radius8),
                onTap: () => onDateSelected(date),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.padding12,
                    vertical: Dimens.padding10,
                  ),
                  child: CustomTextLabelWidget(
                    label: dateLabel,
                    textAlign: TextAlign.start,
                    style: AppStyles.instance.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? context.theme.colorScheme.onPrimaryContainer
                          : context.theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Dimens.space8),
            ...dayEvents.map(
              (CalendarEventData event) => Padding(
                padding: const EdgeInsets.only(bottom: Dimens.space8),
                child: CalendarEventCard(event: event),
              ),
            ),
          ],
        );
      },
    );
  }
}
