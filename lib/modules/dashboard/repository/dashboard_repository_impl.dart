import '../../../core/domain/entities/dashboard_activity_item.dart';
import '../../../core/domain/entities/dashboard_data.dart';
import '../../../core/domain/entities/expense_entity.dart';
import '../../../core/domain/entities/factory_status_entity.dart';
import '../../../core/domain/entities/labor_entity.dart';
import '../../../core/domain/entities/person_entity.dart';
import '../../../core/domain/entities/recurring_expense_entity.dart';
import '../../../core/domain/repositories/dashboard_repository.dart';
import '../../../core/domain/repositories/expense_module_repository.dart';
import '../../../core/domain/repositories/factory_status_repository.dart';
import '../../../core/domain/repositories/labor_repository.dart';
import '../../../core/domain/repositories/person_repository.dart';
import '../../../core/domain/repositories/recurring_expense_repository.dart';
import '../../../service/network/response_handler.dart';
import '../../../service/sync/sync_service.dart';

/// Hive-backed dashboard aggregator.
class DashboardRepositoryImpl implements DashboardRepository {
  /// Creates [DashboardRepositoryImpl].
  DashboardRepositoryImpl({
    required PersonRepository personRepository,
    required LaborRepository laborRepository,
    required ExpenseModuleRepository materialPurchaseRepository,
    required ExpenseModuleRepository truckExpenseRepository,
    required ExpenseModuleRepository maintenanceExpenseRepository,
    required ExpenseModuleRepository electricityExpenseRepository,
    required ExpenseModuleRepository miscellaneousExpenseRepository,
    required RecurringExpenseRepository recurringExpenseRepository,
    required FactoryStatusRepository factoryStatusRepository,
    required SyncService syncService,
  })  : _personRepository = personRepository,
        _laborRepository = laborRepository,
        _materialPurchaseRepository = materialPurchaseRepository,
        _truckExpenseRepository = truckExpenseRepository,
        _maintenanceExpenseRepository = maintenanceExpenseRepository,
        _electricityExpenseRepository = electricityExpenseRepository,
        _miscellaneousExpenseRepository = miscellaneousExpenseRepository,
        _recurringExpenseRepository = recurringExpenseRepository,
        _factoryStatusRepository = factoryStatusRepository,
        _syncService = syncService;

  final PersonRepository _personRepository;
  final LaborRepository _laborRepository;
  final ExpenseModuleRepository _materialPurchaseRepository;
  final ExpenseModuleRepository _truckExpenseRepository;
  final ExpenseModuleRepository _maintenanceExpenseRepository;
  final ExpenseModuleRepository _electricityExpenseRepository;
  final ExpenseModuleRepository _miscellaneousExpenseRepository;
  final RecurringExpenseRepository _recurringExpenseRepository;
  final FactoryStatusRepository _factoryStatusRepository;
  final SyncService _syncService;

  static const int _recentActivityLimit = 10;

  @override
  Future<DashboardData> loadDashboardData() async {
    final List<PersonEntity> persons = await _unwrapList(
      await _personRepository.getAll(),
    );
    final List<LaborEntity> labor = await _unwrapList(
      await _laborRepository.getAll(),
    );
    final int pendingSyncCount = await _syncService.getPendingSyncCount();
    final DateTime? lastSyncAt = await _syncService.getLastSuccessfulSyncAt();

    final List<ExpenseEntity> expenses = await _loadAllExpenses();
    final List<RecurringExpenseEntity> recurringExpenses = await _unwrapList(
      await _recurringExpenseRepository.getAll(),
    );
    final List<FactoryStatusEntity> factoryStatuses =
        await _factoryStatusRepository.getAll();

    factoryStatuses.sort(
      (FactoryStatusEntity a, FactoryStatusEntity b) =>
          b.updatedAt.compareTo(a.updatedAt),
    );
    final FactoryStatusEntity? currentStatus =
        factoryStatuses.isEmpty ? null : factoryStatuses.first;

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
      await _unwrapList(await _materialPurchaseRepository.getAll()),
    );
    expenses.addAll(await _unwrapList(await _truckExpenseRepository.getAll()));
    expenses.addAll(
      await _unwrapList(await _maintenanceExpenseRepository.getAll()),
    );
    expenses.addAll(
      await _unwrapList(await _electricityExpenseRepository.getAll()),
    );
    expenses.addAll(
      await _unwrapList(await _miscellaneousExpenseRepository.getAll()),
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
