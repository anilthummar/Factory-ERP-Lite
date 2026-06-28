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

  Future<void> _onAddEvent(BuildContext context) async {
    final AppString strings = context.appString;

    final CalendarEventType? type = await showModalBottomSheet<CalendarEventType>(
      context: context,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.autorenew),
                title: CustomTextLabelWidget(
                  label: strings.calendarEventRecurringExpenseKey,
                ),
                onTap: () => Navigator.pop(
                  sheetContext,
                  CalendarEventType.recurringExpense,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.build_outlined),
                title: CustomTextLabelWidget(
                  label: strings.calendarEventMaintenanceReminderKey,
                ),
                onTap: () => Navigator.pop(
                  sheetContext,
                  CalendarEventType.maintenanceReminder,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.factory_outlined),
                title: CustomTextLabelWidget(
                  label: strings.calendarEventFactoryEventKey,
                ),
                onTap: () => Navigator.pop(
                  sheetContext,
                  CalendarEventType.factoryEvent,
                ),
              ),
            ],
          ),
        );
      },
    );

    if (!context.mounted || type == null) {
      return;
    }

    final Future<dynamic> navigation = switch (type) {
      CalendarEventType.recurringExpense =>
        context.router.push(const RecurringExpensesRoute()),
      CalendarEventType.maintenanceReminder =>
        context.router.push(const MaintenanceExpensesRoute()),
      CalendarEventType.factoryEvent =>
        context.router.push(const FactoryStatusOverviewRoute()),
      CalendarEventType.holiday => Future<void>.value(),
    };

    await navigation;
    if (!context.mounted) {
      return;
    }
    _loadEventsForCurrentYear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalendarBloc>.value(
      value: _calendarBloc,
      child: BlocBuilder<CalendarBloc, CalendarBlocState>(
        builder: (BuildContext context, CalendarBlocState state) {
          return CalendarPage(
            events: state.events,
            onAddEvent: () => unawaited(_onAddEvent(context)),
          );
        },
      ),
    );
  }
}
