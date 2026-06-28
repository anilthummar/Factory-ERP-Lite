import '../../../../app/translations/app_string/app_string.dart';
import '../domain/enums/explorer_module_type.dart';

/// Localized module badge labels for Records Explorer.
abstract final class ExplorerModuleLabels {
  /// Returns the display label for [moduleType].
  static String label(AppString strings, ExplorerModuleType moduleType) {
    return switch (moduleType) {
      ExplorerModuleType.person => strings.recordsExplorerModulePersonKey,
      ExplorerModuleType.labor => strings.recordsExplorerModuleLaborKey,
      ExplorerModuleType.materialPurchase =>
        strings.recordsExplorerModuleMaterialKey,
      ExplorerModuleType.truckExpense =>
        strings.recordsExplorerModuleTruckKey,
      ExplorerModuleType.maintenanceExpense =>
        strings.recordsExplorerModuleMaintenanceKey,
      ExplorerModuleType.electricityExpense =>
        strings.recordsExplorerModuleElectricityKey,
      ExplorerModuleType.miscellaneousExpense =>
        strings.recordsExplorerModuleMiscKey,
      ExplorerModuleType.recurringExpense =>
        strings.recordsExplorerModuleRecurringKey,
      ExplorerModuleType.factoryStatus =>
        strings.recordsExplorerModuleFactoryKey,
      ExplorerModuleType.calendarEvent =>
        strings.recordsExplorerModuleCalendarKey,
    };
  }
}
