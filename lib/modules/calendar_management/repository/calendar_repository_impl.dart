import '../../../core/domain/entities/expense_entity.dart';
import '../../../core/domain/entities/factory_status_entity.dart';
import '../../../core/domain/entities/recurring_expense_entity.dart';
import '../../../core/domain/repositories/expense_module_repository.dart';
import '../../../core/domain/repositories/factory_status_repository.dart';
import '../../../core/domain/repositories/recurring_expense_repository.dart';
import '../../../service/network/response_handler.dart';
import '../domain/calendar_event_generator.dart';
import '../ui/widget/calendar_event_type.dart';
import 'calendar_repository.dart';

/// Hive-backed calendar event aggregator.
class CalendarRepositoryImpl implements CalendarRepository {
  /// Creates [CalendarRepositoryImpl].
  CalendarRepositoryImpl({
    required RecurringExpenseRepository recurringExpenseRepository,
    required ExpenseModuleRepository maintenanceExpenseRepository,
    required FactoryStatusRepository factoryStatusRepository,
    CalendarEventGenerator? eventGenerator,
  })  : _recurringExpenseRepository = recurringExpenseRepository,
        _maintenanceExpenseRepository = maintenanceExpenseRepository,
        _factoryStatusRepository = factoryStatusRepository,
        _eventGenerator = eventGenerator ?? const CalendarEventGenerator();

  final RecurringExpenseRepository _recurringExpenseRepository;
  final ExpenseModuleRepository _maintenanceExpenseRepository;
  final FactoryStatusRepository _factoryStatusRepository;
  final CalendarEventGenerator _eventGenerator;

  @override
  Future<List<CalendarEventData>> loadEvents({
    required DateTime rangeStart,
    required DateTime rangeEnd,
  }) async {
    final List<CalendarEventData> events = <CalendarEventData>[];

    final List<RecurringExpenseEntity> recurring = await _unwrapList(
      await _recurringExpenseRepository.getAll(),
    );
    for (final RecurringExpenseEntity expense in recurring) {
      final List<DateTime> dates = _eventGenerator.recurringOccurrences(
        startDate: expense.startDate,
        frequency: expense.frequency,
        endDate: expense.endDate,
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
      );
      for (final DateTime date in dates) {
        events.add(
          CalendarEventData(
            id: '${expense.id}_${date.millisecondsSinceEpoch}',
            title: expense.title,
            date: date,
            type: CalendarEventType.recurringExpense,
          ),
        );
      }
    }

    final List<ExpenseEntity> maintenance = await _unwrapList(
      await _maintenanceExpenseRepository.getAll(),
    );
    for (final ExpenseEntity expense in maintenance) {
      if (_isInRange(expense.date, rangeStart, rangeEnd)) {
        events.add(
          CalendarEventData(
            id: expense.id,
            title: expense.title,
            date: expense.date,
            type: CalendarEventType.maintenanceReminder,
          ),
        );
      }
    }

    final List<FactoryStatusEntity> statuses =
        await _factoryStatusRepository.getAll();
    for (final FactoryStatusEntity status in statuses) {
      if (_isInRange(status.updatedAt, rangeStart, rangeEnd)) {
        events.add(
          CalendarEventData(
            id: status.id,
            title: status.status.name,
            date: status.updatedAt,
            type: CalendarEventType.factoryEvent,
          ),
        );
      }
    }

    events.sort(
      (CalendarEventData a, CalendarEventData b) => a.date.compareTo(b.date),
    );
    return events;
  }

  bool _isInRange(DateTime date, DateTime start, DateTime end) {
    final DateTime value = DateTime(date.year, date.month, date.day);
    final DateTime rangeStart = DateTime(start.year, start.month, start.day);
    final DateTime rangeEnd = DateTime(end.year, end.month, end.day);
    return !value.isBefore(rangeStart) && !value.isAfter(rangeEnd);
  }

  Future<List<T>> _unwrapList<T>(ResponseHandler<List<T>> result) async {
    if (result is OnSuccessResponse<List<T>>) {
      return result.response;
    }
    return <T>[];
  }
}
