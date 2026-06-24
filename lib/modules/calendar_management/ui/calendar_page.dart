import 'package:intl/intl.dart';

import '../../../../utils/exports.dart';

/// Factory calendar screen with month/agenda views (UI only).
class CalendarPage extends StatefulWidget {
  /// Creates [CalendarPage].
  const CalendarPage({
    this.events = const <CalendarEventData>[],
    this.onAddEvent,
    super.key,
  });

  /// Events to display on the calendar.
  final List<CalendarEventData> events;

  /// Add event FAB callback placeholder.
  final VoidCallback? onAddEvent;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarViewMode _viewMode = CalendarViewMode.month;
  late DateTime _focusedMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month);
    _selectedDate = calendarDateOnly(now);
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = calendarDateOnly(date);
      _focusedMonth = DateTime(date.year, date.month);
    });
  }

  void _goToPreviousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  void _onAddEvent() {
    widget.onAddEvent?.call();
  }

  @override
  Widget build(BuildContext context) {
    final AppString strings = context.appString;
    final ColorScheme colorScheme = context.theme.colorScheme;
    final Locale locale = Localizations.localeOf(context);
    final List<CalendarEventData> selectedDateEvents =
        calendarEventsForDate(widget.events, _selectedDate);
    final String selectedDateLabel =
        DateFormat.yMMMd(locale.toString()).format(_selectedDate);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: CustomTextLabelWidget(
          label: strings.navCalendarKey,
          textAlign: TextAlign.start,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddEvent,
        icon: const Icon(Icons.add_outlined),
        label: CustomTextLabelWidget(
          label: strings.addCalendarEventKey,
          style: AppStyles.instance.textTheme.labelMedium?.copyWith(
            color: colorScheme.onPrimary,
          ),
        ),
      ),
      body: CustomResponsiveContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Dimens.padding16,
                Dimens.padding8,
                Dimens.padding16,
                Dimens.padding8,
              ),
              child: SegmentedButton<CalendarViewMode>(
                segments: <ButtonSegment<CalendarViewMode>>[
                  ButtonSegment<CalendarViewMode>(
                    value: CalendarViewMode.month,
                    label: CustomTextLabelWidget(
                      label: strings.calendarMonthViewKey,
                    ),
                    icon: const Icon(Icons.calendar_view_month_outlined),
                  ),
                  ButtonSegment<CalendarViewMode>(
                    value: CalendarViewMode.agenda,
                    label: CustomTextLabelWidget(
                      label: strings.calendarAgendaViewKey,
                    ),
                    icon: const Icon(Icons.view_list_outlined),
                  ),
                ],
                selected: <CalendarViewMode>{_viewMode},
                onSelectionChanged: (Set<CalendarViewMode> selection) {
                  setState(() => _viewMode = selection.first);
                },
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.padding8,
                ),
                child: _viewMode == CalendarViewMode.month
                    ? CalendarMonthView(
                        focusedMonth: _focusedMonth,
                        selectedDate: _selectedDate,
                        events: widget.events,
                        onDateSelected: _selectDate,
                        onPreviousMonth: _goToPreviousMonth,
                        onNextMonth: _goToNextMonth,
                      )
                    : CalendarAgendaView(
                        focusedMonth: _focusedMonth,
                        events: widget.events,
                        selectedDate: _selectedDate,
                        onDateSelected: _selectDate,
                      ),
              ),
            ),
            const Divider(height: Dimens.space1),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Dimens.padding16,
                Dimens.padding12,
                Dimens.padding16,
                Dimens.padding8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomTextLabelWidget(
                    label: strings.calendarSelectedDateEventsKey,
                    textAlign: TextAlign.start,
                    style: AppStyles.instance.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: Dimens.space4),
                  CustomTextLabelWidget(
                    label: selectedDateLabel,
                    textAlign: TextAlign.start,
                    style: AppStyles.instance.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: selectedDateEvents.isEmpty
                  ? const CalendarSelectedDateEmptyView()
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.padding16,
                      ),
                      itemCount: selectedDateEvents.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: Dimens.space8),
                      itemBuilder: (BuildContext context, int index) {
                        return CalendarEventCard(
                          event: selectedDateEvents[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
