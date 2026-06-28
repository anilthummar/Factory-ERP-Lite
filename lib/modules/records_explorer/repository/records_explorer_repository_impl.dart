import '../../../core/domain/entities/expense_entity.dart';
import '../../../core/domain/entities/factory_status_entity.dart';
import '../../../core/domain/entities/labor_entity.dart';
import '../../../core/domain/entities/person_entity.dart';
import '../../../core/domain/entities/recurring_expense_entity.dart';
import '../../../service/network/response_handler.dart';
import '../../calendar_management/domain/usecases/get_calendar_events_use_case.dart';
import '../../calendar_management/ui/widget/calendar_event_type.dart';
import '../../electricity_expenses/domain/usecases/electricity_expense_use_cases.dart';
import '../../factory_status/domain/usecases/get_factory_status_history_use_case.dart';
import '../../labor_management/domain/usecases/get_labor_use_case.dart';
import '../../maintenance_expenses/domain/usecases/maintenance_expense_use_cases.dart';
import '../../material_purchases/domain/usecases/material_purchase_use_cases.dart';
import '../../miscellaneous_expenses/domain/usecases/miscellaneous_expense_use_cases.dart';
import '../../person_management/domain/usecases/get_persons_use_case.dart';
import '../../recurring_expenses/domain/usecases/recurring_expense_use_cases.dart';
import '../../truck_expenses/domain/usecases/truck_expense_use_cases.dart';
import '../domain/entities/explorer_record_item.dart';
import 'explorer_record_mapper.dart';
import 'records_explorer_repository.dart';

/// Aggregates ERP records from existing module repositories.
class RecordsExplorerRepositoryImpl implements RecordsExplorerRepository {
  /// Creates [RecordsExplorerRepositoryImpl].
  RecordsExplorerRepositoryImpl({
    required GetPersonsUseCase getPersonsUseCase,
    required GetLaborUseCase getLaborUseCase,
    required GetMaterialPurchasesUseCase getMaterialPurchasesUseCase,
    required GetTruckExpensesUseCase getTruckExpensesUseCase,
    required GetMaintenanceExpensesUseCase getMaintenanceExpensesUseCase,
    required GetElectricityExpensesUseCase getElectricityExpensesUseCase,
    required GetMiscellaneousExpensesUseCase getMiscellaneousExpensesUseCase,
    required GetRecurringExpensesUseCase getRecurringExpensesUseCase,
    required GetFactoryStatusHistoryUseCase getFactoryStatusHistoryUseCase,
    required GetCalendarEventsUseCase getCalendarEventsUseCase,
  })  : _getPersonsUseCase = getPersonsUseCase,
        _getLaborUseCase = getLaborUseCase,
        _getMaterialPurchasesUseCase = getMaterialPurchasesUseCase,
        _getTruckExpensesUseCase = getTruckExpensesUseCase,
        _getMaintenanceExpensesUseCase = getMaintenanceExpensesUseCase,
        _getElectricityExpensesUseCase = getElectricityExpensesUseCase,
        _getMiscellaneousExpensesUseCase = getMiscellaneousExpensesUseCase,
        _getRecurringExpensesUseCase = getRecurringExpensesUseCase,
        _getFactoryStatusHistoryUseCase = getFactoryStatusHistoryUseCase,
        _getCalendarEventsUseCase = getCalendarEventsUseCase;

  final GetPersonsUseCase _getPersonsUseCase;
  final GetLaborUseCase _getLaborUseCase;
  final GetMaterialPurchasesUseCase _getMaterialPurchasesUseCase;
  final GetTruckExpensesUseCase _getTruckExpensesUseCase;
  final GetMaintenanceExpensesUseCase _getMaintenanceExpensesUseCase;
  final GetElectricityExpensesUseCase _getElectricityExpensesUseCase;
  final GetMiscellaneousExpensesUseCase _getMiscellaneousExpensesUseCase;
  final GetRecurringExpensesUseCase _getRecurringExpensesUseCase;
  final GetFactoryStatusHistoryUseCase _getFactoryStatusHistoryUseCase;
  final GetCalendarEventsUseCase _getCalendarEventsUseCase;

  @override
  Future<List<ExplorerRecordItem>> loadAllRecords() async {
    final List<ExplorerRecordItem> records = <ExplorerRecordItem>[];

    final List<PersonEntity> persons =
        await _unwrapList(await _getPersonsUseCase());
    records.addAll(persons.map(ExplorerRecordMapper.fromPerson));

    final List<LaborEntity> labor =
        await _unwrapList(await _getLaborUseCase());
    records.addAll(labor.map(ExplorerRecordMapper.fromLabor));

    records.addAll(
      (await _unwrapList(await _getMaterialPurchasesUseCase()))
          .map(ExplorerRecordMapper.fromExpense),
    );
    records.addAll(
      (await _unwrapList(await _getTruckExpensesUseCase()))
          .map(ExplorerRecordMapper.fromExpense),
    );
    records.addAll(
      (await _unwrapList(await _getMaintenanceExpensesUseCase()))
          .map(ExplorerRecordMapper.fromExpense),
    );
    records.addAll(
      (await _unwrapList(await _getElectricityExpensesUseCase()))
          .map(ExplorerRecordMapper.fromExpense),
    );
    records.addAll(
      (await _unwrapList(await _getMiscellaneousExpensesUseCase()))
          .map(ExplorerRecordMapper.fromExpense),
    );

    final List<RecurringExpenseEntity> recurring =
        await _unwrapList(await _getRecurringExpensesUseCase());
    records.addAll(recurring.map(ExplorerRecordMapper.fromRecurring));

    final List<FactoryStatusEntity> factoryHistory =
        await _getFactoryStatusHistoryUseCase();
    records.addAll(factoryHistory.map(ExplorerRecordMapper.fromFactoryStatus));

    final DateTime now = DateTime.now();
    final DateTime rangeStart = DateTime(now.year - 5);
    final DateTime rangeEnd = DateTime(now.year + 5, 12, 31);
    final List<CalendarEventData> events = await _getCalendarEventsUseCase(
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
    );
    records.addAll(events.map(ExplorerRecordMapper.fromCalendarEvent));

    return records;
  }

  Future<List<T>> _unwrapList<T>(ResponseHandler<List<T>> result) async {
    if (result is OnSuccessResponse<List<T>>) {
      return result.response;
    }
    return <T>[];
  }
}
