import '../../../../utils/exports.dart';

/// Empty state when no events exist for the selected date.
class CalendarSelectedDateEmptyView extends StatelessWidget {
  /// Creates [CalendarSelectedDateEmptyView].
  const CalendarSelectedDateEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return CustomEmptyStateWidget(
      icon: Icons.event_busy_outlined,
      iconSize: Dimens.size48,
      title: strings.calendarNoEventsTitleKey,
      message: strings.calendarNoEventsMessageKey,
    );
  }
}

/// Empty state when the agenda view has no events for the month.
class CalendarAgendaEmptyView extends StatelessWidget {
  /// Creates [CalendarAgendaEmptyView].
  const CalendarAgendaEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;

    return CustomEmptyStateWidget(
      icon: Icons.calendar_month_outlined,
      iconSize: Dimens.size48,
      title: strings.calendarAgendaEmptyTitleKey,
      message: strings.calendarAgendaEmptyMessageKey,
    );
  }
}
