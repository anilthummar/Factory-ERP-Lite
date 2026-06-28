import '../../../core/domain/entities/dashboard_activity_item.dart';
import '../../../core/domain/entities/dashboard_data.dart';
import '../../../core/domain/entities/expense_entity.dart';
import '../../../core/domain/entities/factory_status_entity.dart';
import '../../../core/domain/entities/labor_entity.dart';
import '../../../core/domain/entities/person_entity.dart';
import '../../../core/domain/entities/recurring_expense_entity.dart';
import '../../../core/domain/repositories/dashboard_repository.dart';
import '../../../service/network/response_handler.dart';
import '../../../service/sync/sync_service.dart';
import '../../electricity_expenses/domain/usecases/electricity_expense_use_cases.dart';
import '../../factory_status/domain/usecases/get_current_factory_status_use_case.dart';
import '../../factory_status/domain/usecases/get_factory_status_history_use_case.dart';
import '../../labor_management/domain/usecases/get_labor_use_case.dart';
import '../../maintenance_expenses/domain/usecases/maintenance_expense_use_cases.dart';
import '../../material_purchases/domain/usecases/material_purchase_use_cases.dart';
import '../../miscellaneous_expenses/domain/usecases/miscellaneous_expense_use_cases.dart';
import '../../person_management/domain/usecases/get_persons_use_case.dart';
import '../../recurring_expenses/domain/usecases/recurring_expense_use_cases.dart';
import '../../truck_expenses/domain/usecases/truck_expense_use_cases.dart';

/// Hive-backed dashboard aggregator using existing module use cases.
class DashboardRepositoryImpl implements DashboardRepository {
  /// Creates [DashboardRepositoryImpl].
  DashboardRepositoryImpl({
    required GetPersonsUseCase getPersonsUseCase,
    required GetLaborUseCase getLaborUseCase,
    required GetMaterialPurchasesUseCase getMaterialPurchasesUseCase,
    required GetTruckExpensesUseCase getTruckExpensesUseCase,
    required GetMaintenanceExpensesUseCase getMaintenanceExpensesUseCase,
    required GetElectricityExpensesUseCase getElectricityExpensesUseCase,
    required GetMiscellaneousExpensesUseCase getMiscellaneousExpensesUseCase,
    required GetRecurringExpensesUseCase getRecurringExpensesUseCase,
    required GetCurrentFactoryStatusUseCase getCurrentFactoryStatusUseCase,
    required GetFactoryStatusHistoryUseCase getFactoryStatusHistoryUseCase,
    required SyncService syncService,
  })  : _getPersonsUseCase = getPersonsUseCase,
        _getLaborUseCase = getLaborUseCase,
        _getMaterialPurchasesUseCase = getMaterialPurchasesUseCase,
        _getTruckExpensesUseCase = getTruckExpensesUseCase,
        _getMaintenanceExpensesUseCase = getMaintenanceExpensesUseCase,
        _getElectricityExpensesUseCase = getElectricityExpensesUseCase,
        _getMiscellaneousExpensesUseCase = getMiscellaneousExpensesUseCase,
        _getRecurringExpensesUseCase = getRecurringExpensesUseCase,
        _getCurrentFactoryStatusUseCase = getCurrentFactoryStatusUseCase,
        _getFactoryStatusHistoryUseCase = getFactoryStatusHistoryUseCase,
        _syncService = syncService;

  final GetPersonsUseCase _getPersonsUseCase;
  final GetLaborUseCase _getLaborUseCase;
  final GetMaterialPurchasesUseCase _getMaterialPurchasesUseCase;
  final GetTruckExpensesUseCase _getTruckExpensesUseCase;
  final GetMaintenanceExpensesUseCase _getMaintenanceExpensesUseCase;
  final GetElectricityExpensesUseCase _getElectricityExpensesUseCase;
  final GetMiscellaneousExpensesUseCase _getMiscellaneousExpensesUseCase;
  final GetRecurringExpensesUseCase _getRecurringExpensesUseCase;
  final GetCurrentFactoryStatusUseCase _getCurrentFactoryStatusUseCase;
  final GetFactoryStatusHistoryUseCase _getFactoryStatusHistoryUseCase;
  final SyncService _syncService;

  static const int _recentActivityLimit = 10;

  @override
  Future<DashboardData> loadDashboardData() async {
    final List<PersonEntity> persons =
        await _unwrapList(await _getPersonsUseCase());
    final List<LaborEntity> labor = await _unwrapList(await _getLaborUseCase());
    final int pendingSyncCount = await _syncService.getPendingSyncCount();
    final DateTime? lastSyncAt = await _syncService.getLastSuccessfulSyncAt();

    final List<ExpenseEntity> expenses = await _loadAllExpenses();
    final List<RecurringExpenseEntity> recurringExpenses =
        await _unwrapList(await _getRecurringExpensesUseCase());
    final FactoryStatusEntity? currentStatus =
        await _getCurrentFactoryStatusUseCase();
    final List<FactoryStatusEntity> factoryStatuses =
        await _getFactoryStatusHistoryUseCase();

    final List<DashboardActivityItem> recentActivities =
        _buildRecentActivities(
      persons: persons,
      labor: labor,
      expenses: expenses,
      recurringExpenses: recurringExpenses,
      factoryStatuses: factoryStatuses,
    );

    return DashboardData(
      totalPersons: persons.length,
      totalLabor: labor.length,
      totalExpenses: expenses.length,
      pendingSyncCount: pendingSyncCount,
      lastSyncAt: lastSyncAt,
      currentFactoryStatus: currentStatus?.status,
      currentFactoryStatusNotes: currentStatus?.notes,
      factoryStatusUpdatedAt: currentStatus?.updatedAt,
      recentActivities: recentActivities,
    );
  }

  Future<List<ExpenseEntity>> _loadAllExpenses() async {
    final List<ExpenseEntity> expenses = <ExpenseEntity>[];
    expenses.addAll(
      await _unwrapList(await _getMaterialPurchasesUseCase()),
    );
    expenses.addAll(await _unwrapList(await _getTruckExpensesUseCase()));
    expenses.addAll(
      await _unwrapList(await _getMaintenanceExpensesUseCase()),
    );
    expenses.addAll(
      await _unwrapList(await _getElectricityExpensesUseCase()),
    );
    expenses.addAll(
      await _unwrapList(await _getMiscellaneousExpensesUseCase()),
    );
    return expenses;
  }

  List<DashboardActivityItem> _buildRecentActivities({
    required List<PersonEntity> persons,
    required List<LaborEntity> labor,
    required List<ExpenseEntity> expenses,
    required List<RecurringExpenseEntity> recurringExpenses,
    required List<FactoryStatusEntity> factoryStatuses,
  }) {
    final List<DashboardActivityItem> activities = <DashboardActivityItem>[];

    for (final PersonEntity person in persons) {
      activities.add(
        DashboardActivityItem(
          id: person.id,
          title: person.name,
          subtitle: 'Person',
          occurredAt: person.updatedAt,
          source: DashboardActivitySource.person,
        ),
      );
    }

    for (final LaborEntity entry in labor) {
      activities.add(
        DashboardActivityItem(
          id: entry.id,
          title: entry.name,
          subtitle: entry.skill,
          occurredAt: entry.updatedAt,
          source: DashboardActivitySource.labor,
        ),
      );
    }

    for (final ExpenseEntity expense in expenses) {
      activities.add(
        DashboardActivityItem(
          id: expense.id,
          title: expense.title,
          subtitle: expense.category.name,
          occurredAt: expense.updatedAt,
          source: DashboardActivitySource.expense,
        ),
      );
    }

    for (final RecurringExpenseEntity expense in recurringExpenses) {
      activities.add(
        DashboardActivityItem(
          id: expense.id,
          title: expense.title,
          subtitle: expense.frequency.name,
          occurredAt: expense.updatedAt,
          source: DashboardActivitySource.recurringExpense,
        ),
      );
    }

    for (final FactoryStatusEntity status in factoryStatuses) {
      activities.add(
        DashboardActivityItem(
          id: status.id,
          title: status.status.name,
          subtitle: status.notes ?? 'Factory status',
          occurredAt: status.updatedAt,
          source: DashboardActivitySource.factoryStatus,
        ),
      );
    }

    activities.sort(
      (DashboardActivityItem a, DashboardActivityItem b) =>
          b.occurredAt.compareTo(a.occurredAt),
    );

    if (activities.length <= _recentActivityLimit) {
      return activities;
    }
    return activities.sublist(0, _recentActivityLimit);
  }

  Future<List<T>> _unwrapList<T>(ResponseHandler<List<T>> result) async {
    if (result is OnSuccessResponse<List<T>>) {
      return result.response;
    }
    return <T>[];
  }
}
