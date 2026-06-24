import '../../../../utils/exports.dart';

/// Calendar tab — hosts [CalendarPage] with live Hive data.
class CalendarTabPage extends StatefulWidget {
  /// Creates [CalendarTabPage].
  const CalendarTabPage({super.key});

  @override
  State<CalendarTabPage> createState() => _CalendarTabPageState();
}

class _CalendarTabPageState extends State<CalendarTabPage> {
  late final CalendarBloc _calendarBloc;

  @override
  void initState() {
    super.initState();
    _calendarBloc = CalendarBloc(
      getCalendarEventsUseCase: getIt<GetCalendarEventsUseCase>(),
    );
    _loadEventsForCurrentYear();
  }

  @override
  void dispose() {
    unawaited(_calendarBloc.close());
    super.dispose();
  }

  void _loadEventsForCurrentYear() {
    final DateTime now = DateTime.now();
    _calendarBloc.add(
      CalendarLoadRequested(
        rangeStart: DateTime(now.year, 1, 1),
        rangeEnd: DateTime(now.year, 12, 31),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalendarBloc>.value(
      value: _calendarBloc,
      child: BlocBuilder<CalendarBloc, CalendarBlocState>(
        builder: (BuildContext context, CalendarBlocState state) {
          return CalendarPage(
            events: state.events,
          );
        },
      ),
    );
  }
}
