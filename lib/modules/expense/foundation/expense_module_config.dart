import 'package:hive_ce/hive_ce.dart';

import '../../../core/domain/enums/expense_category.dart';
import '../../../service/hive/hive_box_names.dart';
import '../../../service/hive/hive_manager.dart';
import '../model/local/expense_hive_model.dart';

/// Hive box + category configuration for a one-time expense module.
class ExpenseModuleConfig {
  /// Creates [ExpenseModuleConfig].
  const ExpenseModuleConfig({
    required this.category,
    required this.boxName,
    required this.idPrefix,
    required this.boxAccessor,
    required this.isBoxOpenAccessor,
  });

  /// Material purchase module configuration.
  static final ExpenseModuleConfig materialPurchase = ExpenseModuleConfig(
    category: ExpenseCategory.materialPurchase,
    boxName: HiveBoxNames.materialPurchases,
    idPrefix: 'material_purchase_',
    boxAccessor: (HiveManager manager) => manager.materialPurchaseBox,
    isBoxOpenAccessor: (HiveManager manager) => manager.isMaterialPurchaseBoxOpen,
  );

  /// Truck expense module configuration.
  static final ExpenseModuleConfig truckExpense = ExpenseModuleConfig(
    category: ExpenseCategory.truck,
    boxName: HiveBoxNames.truckExpenses,
    idPrefix: 'truck_expense_',
    boxAccessor: (HiveManager manager) => manager.truckExpenseBox,
    isBoxOpenAccessor: (HiveManager manager) => manager.isTruckExpenseBoxOpen,
  );

  /// Maintenance expense module configuration.
  static final ExpenseModuleConfig maintenanceExpense = ExpenseModuleConfig(
    category: ExpenseCategory.maintenance,
    boxName: HiveBoxNames.maintenanceExpenses,
    idPrefix: 'maintenance_expense_',
    boxAccessor: (HiveManager manager) => manager.maintenanceExpenseBox,
    isBoxOpenAccessor: (HiveManager manager) =>
        manager.isMaintenanceExpenseBoxOpen,
  );

  /// Electricity expense module configuration.
  static final ExpenseModuleConfig electricityExpense = ExpenseModuleConfig(
    category: ExpenseCategory.electricity,
    boxName: HiveBoxNames.electricityExpenses,
    idPrefix: 'electricity_expense_',
    boxAccessor: (HiveManager manager) => manager.electricityExpenseBox,
    isBoxOpenAccessor: (HiveManager manager) =>
        manager.isElectricityExpenseBoxOpen,
  );

  /// Miscellaneous expense module configuration.
  static final ExpenseModuleConfig miscellaneousExpense = ExpenseModuleConfig(
    category: ExpenseCategory.miscellaneous,
    boxName: HiveBoxNames.miscellaneousExpenses,
    idPrefix: 'miscellaneous_expense_',
    boxAccessor: (HiveManager manager) => manager.miscellaneousExpenseBox,
    isBoxOpenAccessor: (HiveManager manager) =>
        manager.isMiscellaneousExpenseBoxOpen,
  );

  /// Expense category for sync metadata.
  final ExpenseCategory category;

  /// Hive box name for this module.
  final String boxName;

  /// Prefix for generated record ids.
  final String idPrefix;

  /// Resolves the typed Hive box for this module.
  final Box<ExpenseHiveModel> Function(HiveManager manager) boxAccessor;

  /// Whether this module's Hive box is open.
  final bool Function(HiveManager manager) isBoxOpenAccessor;
}
