import '../../../core/domain/entities/expense_entity.dart';
import '../../../core/domain/entities/labor_entity.dart';
import '../../../core/domain/entities/person_entity.dart';
import '../../../core/domain/entities/recurring_expense_entity.dart';
import '../../../service/network/response_handler.dart';
import '../../../service/sync/sync_service.dart';
import '../../electricity_expenses/domain/usecases/electricity_expense_use_cases.dart';
import '../../labor_management/domain/usecases/get_labor_use_case.dart';
import '../../maintenance_expenses/domain/usecases/maintenance_expense_use_cases.dart';
import '../../material_purchases/domain/usecases/material_purchase_use_cases.dart';
import '../../miscellaneous_expenses/domain/usecases/miscellaneous_expense_use_cases.dart';
import '../../person_management/domain/usecases/get_persons_use_case.dart';
import '../../recurring_expenses/domain/usecases/recurring_expense_use_cases.dart';
import '../../truck_expenses/domain/usecases/truck_expense_use_cases.dart';
import '../domain/models/report_data_snapshot.dart';

/// Loads live ERP data for PDF report generation.
class ReportDataRepository {
  /// Creates [ReportDataRepository].
  ReportDataRepository({
    required GetPersonsUseCase getPersonsUseCase,
    required GetLaborUseCase getLaborUseCase,
    required GetMaterialPurchasesUseCase getMaterialPurchasesUseCase,
    required GetTruckExpensesUseCase getTruckExpensesUseCase,
    required GetMaintenanceExpensesUseCase getMaintenanceExpensesUseCase,
    required GetElectricityExpensesUseCase getElectricityExpensesUseCase,
    required GetMiscellaneousExpensesUseCase getMiscellaneousExpensesUseCase,
    required GetRecurringExpensesUseCase getRecurringExpensesUseCase,
    required SyncService syncService,
  })  : _getPersonsUseCase = getPersonsUseCase,
        _getLaborUseCase = getLaborUseCase,
        _getMaterialPurchasesUseCase = getMaterialPurchasesUseCase,
        _getTruckExpensesUseCase = getTruckExpensesUseCase,
        _getMaintenanceExpensesUseCase = getMaintenanceExpensesUseCase,
        _getElectricityExpensesUseCase = getElectricityExpensesUseCase,
        _getMiscellaneousExpensesUseCase = getMiscellaneousExpensesUseCase,
        _getRecurringExpensesUseCase = getRecurringExpensesUseCase,
        _syncService = syncService;

  final GetPersonsUseCase _getPersonsUseCase;
  final GetLaborUseCase _getLaborUseCase;
  final GetMaterialPurchasesUseCase _getMaterialPurchasesUseCase;
  final GetTruckExpensesUseCase _getTruckExpensesUseCase;
  final GetMaintenanceExpensesUseCase _getMaintenanceExpensesUseCase;
  final GetElectricityExpensesUseCase _getElectricityExpensesUseCase;
  final GetMiscellaneousExpensesUseCase _getMiscellaneousExpensesUseCase;
  final GetRecurringExpensesUseCase _getRecurringExpensesUseCase;
  final SyncService _syncService;

  /// Captures a point-in-time snapshot from local Hive repositories.
  Future<ReportDataSnapshot> loadSnapshot() async {
    final List<PersonEntity> persons =
        await _unwrapList(await _getPersonsUseCase());
    final List<LaborEntity> labor = await _unwrapList(await _getLaborUseCase());
    final List<ExpenseEntity> expenses = await _loadAllExpenses();
    final List<RecurringExpenseEntity> recurringExpenses =
        await _unwrapList(await _getRecurringExpensesUseCase());
    final int pendingSyncCount = await _syncService.getPendingSyncCount();

    return ReportDataSnapshot(
      persons: persons,
      labor: labor,
      expenses: expenses,
      recurringExpenses: recurringExpenses,
      pendingSyncCount: pendingSyncCount,
      generatedAt: DateTime.now(),
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
    expenses.sort(
      (ExpenseEntity a, ExpenseEntity b) => b.date.compareTo(a.date),
    );
    return expenses;
  }

  Future<List<T>> _unwrapList<T>(ResponseHandler<List<T>> result) async {
    if (result is OnSuccessResponse<List<T>>) {
      return result.response;
    }
    return <T>[];
  }
}
