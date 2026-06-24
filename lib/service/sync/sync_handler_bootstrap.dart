import '../../core/sync/sync_module_type.dart';
import '../hive/hive_manager.dart';
import '../../modules/expense/foundation/expense_module_config.dart';
import 'handlers/factory_status_sync_module_handler.dart';
import 'handlers/expense_sync_module_handler.dart';
import 'handlers/labor_sync_module_handler.dart';
import 'handlers/person_sync_module_handler.dart';
import 'handlers/recurring_expense_sync_module_handler.dart';
import 'handlers/sync_handler_registry.dart';
import 'handlers/sync_module_handler.dart';

/// Registers default module sync handlers for implemented ERP modules.
SyncHandlerRegistry createDefaultSyncHandlerRegistry({HiveManager? hiveManager}) {
  final SyncHandlerRegistry registry = SyncHandlerRegistry();
  final HiveManager manager = hiveManager ?? HiveManager.instance;

  final List<SyncModuleHandler> handlers = <SyncModuleHandler>[
    PersonSyncModuleHandler(hiveManager: manager),
    LaborSyncModuleHandler(hiveManager: manager),
    ExpenseSyncModuleHandler(
      moduleType: SyncModuleType.materialPurchases,
      config: ExpenseModuleConfig.materialPurchase,
      hiveManager: manager,
    ),
    ExpenseSyncModuleHandler(
      moduleType: SyncModuleType.truckExpenses,
      config: ExpenseModuleConfig.truckExpense,
      hiveManager: manager,
    ),
    ExpenseSyncModuleHandler(
      moduleType: SyncModuleType.maintenanceExpenses,
      config: ExpenseModuleConfig.maintenanceExpense,
      hiveManager: manager,
    ),
    ExpenseSyncModuleHandler(
      moduleType: SyncModuleType.electricityExpenses,
      config: ExpenseModuleConfig.electricityExpense,
      hiveManager: manager,
    ),
    ExpenseSyncModuleHandler(
      moduleType: SyncModuleType.miscellaneousExpenses,
      config: ExpenseModuleConfig.miscellaneousExpense,
      hiveManager: manager,
    ),
    RecurringExpenseSyncModuleHandler(hiveManager: manager),
    FactoryStatusSyncModuleHandler(hiveManager: manager),
  ];

  for (final SyncModuleHandler handler in handlers) {
    registry.register(handler);
  }

  return registry;
}
