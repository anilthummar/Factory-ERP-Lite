import '../../../../core/domain/entities/factory_status_entity.dart';
import '../../../../core/domain/repositories/factory_status_repository.dart';
import '../../../../utils/exports.dart';
import '../entities/explorer_record_item.dart';
import '../enums/explorer_module_type.dart';

/// Deletes an explorer record via the owning module repository.
class DeleteExplorerRecordUseCase {
  /// Creates [DeleteExplorerRecordUseCase].
  const DeleteExplorerRecordUseCase({
    required DeletePersonUseCase deletePersonUseCase,
    required DeleteLaborUseCase deleteLaborUseCase,
    required DeleteMaterialPurchaseUseCase deleteMaterialPurchaseUseCase,
    required DeleteTruckExpenseUseCase deleteTruckExpenseUseCase,
    required DeleteMaintenanceExpenseUseCase deleteMaintenanceExpenseUseCase,
    required DeleteElectricityExpenseUseCase deleteElectricityExpenseUseCase,
    required DeleteMiscellaneousExpenseUseCase deleteMiscellaneousExpenseUseCase,
    required DeleteRecurringExpenseUseCase deleteRecurringExpenseUseCase,
    required FactoryStatusRepository factoryStatusRepository,
  })  : _deletePersonUseCase = deletePersonUseCase,
        _deleteLaborUseCase = deleteLaborUseCase,
        _deleteMaterialPurchaseUseCase = deleteMaterialPurchaseUseCase,
        _deleteTruckExpenseUseCase = deleteTruckExpenseUseCase,
        _deleteMaintenanceExpenseUseCase = deleteMaintenanceExpenseUseCase,
        _deleteElectricityExpenseUseCase = deleteElectricityExpenseUseCase,
        _deleteMiscellaneousExpenseUseCase = deleteMiscellaneousExpenseUseCase,
        _deleteRecurringExpenseUseCase = deleteRecurringExpenseUseCase,
        _factoryStatusRepository = factoryStatusRepository;

  final DeletePersonUseCase _deletePersonUseCase;
  final DeleteLaborUseCase _deleteLaborUseCase;
  final DeleteMaterialPurchaseUseCase _deleteMaterialPurchaseUseCase;
  final DeleteTruckExpenseUseCase _deleteTruckExpenseUseCase;
  final DeleteMaintenanceExpenseUseCase _deleteMaintenanceExpenseUseCase;
  final DeleteElectricityExpenseUseCase _deleteElectricityExpenseUseCase;
  final DeleteMiscellaneousExpenseUseCase _deleteMiscellaneousExpenseUseCase;
  final DeleteRecurringExpenseUseCase _deleteRecurringExpenseUseCase;
  final FactoryStatusRepository _factoryStatusRepository;

  /// Deletes [record] using the appropriate module delete path.
  Future<void> call(ExplorerRecordItem record) async {
    switch (record.moduleType) {
      case ExplorerModuleType.person:
        await _deletePersonUseCase(record.sourceId);
      case ExplorerModuleType.labor:
        await _deleteLaborUseCase(record.sourceId);
      case ExplorerModuleType.materialPurchase:
        await _deleteMaterialPurchaseUseCase(record.sourceId);
      case ExplorerModuleType.truckExpense:
        await _deleteTruckExpenseUseCase(record.sourceId);
      case ExplorerModuleType.maintenanceExpense:
        await _deleteMaintenanceExpenseUseCase(record.sourceId);
      case ExplorerModuleType.electricityExpense:
        await _deleteElectricityExpenseUseCase(record.sourceId);
      case ExplorerModuleType.miscellaneousExpense:
        await _deleteMiscellaneousExpenseUseCase(record.sourceId);
      case ExplorerModuleType.recurringExpense:
        await _deleteRecurringExpenseUseCase(record.sourceId);
      case ExplorerModuleType.factoryStatus:
        await _factoryStatusRepository.delete(record.sourceId);
      case ExplorerModuleType.calendarEvent:
        throw UnsupportedError('Calendar events cannot be deleted from explorer.');
    }
  }
}
