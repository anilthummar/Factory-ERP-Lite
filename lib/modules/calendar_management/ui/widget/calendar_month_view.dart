import 'package:intl/intl.dart';

import '../../../../utils/exports.dart';

/// Monthly calendar grid with event indicators.
class CalendarMonthView extends StatelessWidget {
  /// Creates [CalendarMonthView].
  const CalendarMonthView({
    required this.focusedMonth,
    required this.selectedDate,
    required this.events,
    required this.onDateSelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
    super.key,
  });

  /// Month currently displayed.
  final DateTime focusedMonth;

  /// Currently highlighted date.
  final DateTime selectedDate;

  /// All events used for day indicators.
  final List<CalendarEventData> events;

  /// Called when a day cell is tapped.
  final ValueChanged<DateTime> onDateSelected;

  /// Navigate to previous month.
  final VoidCallback onPreviousMonth;

  /// Navigate to next month.
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final Locale locale = Localizations.localeOf(context);
    final ColorScheme colorScheme = context.theme.colorScheme;
    final DateTime monthStart =
        DateTime(focusedMonth.year, focusedMonth.month);
    final int daysInMonth =
        DateTime(focusedMonth.year, focusedMonth.month + 1, 0).day;
    final int leadingBlankDays = _leadingBlankDays(
      monthStart,
      localizations.firstDayOfWeekIndex,
    );
    final int totalCells = leadingBlankDays + daysInMonth;
    final int rowCount = (totalCells / 7).ceil();
    final String monthLabel =
        DateFormat.yMMMM(locale.toString()).format(monthStart);
    final List<String> weekdayLabels = _weekdayLabels(localizations);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.padding8),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: onPreviousMonth,
                icon: const Icon(Icons.chevron_left),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              ),
              Expanded(
                child: CustomTextLabelWidget(
                  label: monthLabel,
                  style: AppStyles.instance.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              IconButton(
                onPressed: onNextMonth,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        const SizedBox(height: Dimens.space8),
        Row(
          children: weekdayLabels
              .map(
                (String label) => Expanded(
                  child: CustomTextLabelWidget(
                    label: label,
                    style: AppStyles.instance.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: Dimens.space8),
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: Dimens.space4,
              crossAxisSpacing: Dimens.space4,
            ),
            itemCount: rowCount * 7,
            itemBuilder: (BuildContext context, int index) {
              final int dayIndex = index - leadingBlankDays + 1;
              if (index < leadingBlankDays || dayIndex > daysInMonth) {
                return const SizedBox.shrink();
              }

              final DateTime date = DateTime(
                focusedMonth.year,
                focusedMonth.month,
                dayIndex,
              );
              final bool isSelected =
                  calendarIsSameDay(date, selectedDate);
              final bool isToday =
                  calendarIsSameDay(date, DateTime.now());
              final List<CalendarEventType> indicators =
                  calendarEventTypesForDate(events, date);

              return _DayCell(
                day: dayIndex,
                isSelected: isSelected,
                isToday: isToday,
                indicators: indicators,
                onTap: () => onDateSelected(date),
              );
            },
          ),
        ),
      ],
    );
  }

  int _leadingBlankDays(DateTime monthStart, int firstDayOfWeekIndex) {
    final int weekdayIndex = monthStart.weekday % 7;
    return (weekdayIndex - firstDayOfWeekIndex + 7) % 7;
  }

  List<String> _weekdayLabels(MaterialLocalizations localizations) {
    final List<String> labels = localizations.narrowWeekdays;
    final int firstDay = localizations.firstDayOfWeekIndex;
    return <String>[
      ...labels.sublist(firstDay),
      ...labels.sublist(0, firstDay),
    ];
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.indicators,
    required this.onTap,
  });

  final int day;
  final bool isSelected;
  final bool isToday;
  final List<CalendarEventType> indicators;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;
    final Color? backgroundColor = isSelected
        ? colorScheme.primaryContainer
        : isToday
            ? colorScheme.surfaceContainerHighest
            : null;
    final Color textColor = isSelected
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurface;

    return Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: BorderRadius.circular(Dimens.radius8),
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimens.radius8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimens.padding6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomTextLabelWidget(
                label: '$day',
                style: AppStyles.instance.textTheme.bodyMedium?.copyWith(
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                  color: textColor,
                ),
              ),
              const SizedBox(height: Dimens.space4),
              SizedBox(
                height: Dimens.space8,
                child: indicators.isEmpty
                    ? const SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: indicators
                            .take(3)
                            .map(
                              (CalendarEventType type) => Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: Dimens.padding2,
                                ),
                                decoration: BoxDecoration(
                                  color: type.color(colorScheme),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
