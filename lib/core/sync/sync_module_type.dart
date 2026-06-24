/// Identifies a syncable ERP module in the offline-first pipeline.
enum SyncModuleType {
  /// Person management records.
  personManagement,

  /// Labor management records.
  laborManagement,

  /// Material purchase expenses.
  materialPurchases,

  /// Truck expenses.
  truckExpenses,

  /// Maintenance expenses.
  maintenanceExpenses,

  /// Electricity expenses.
  electricityExpenses,

  /// Miscellaneous expenses.
  miscellaneousExpenses,

  /// Recurring expenses.
  recurringExpenses,

  /// Factory status records.
  factoryStatus,
}

/// Parses [SyncModuleType] from persisted queue values.
SyncModuleType syncModuleTypeFromString(String? value) {
  return SyncModuleType.values.firstWhere(
    (SyncModuleType module) => module.name == value,
    orElse: () => SyncModuleType.personManagement,
  );
}

/// Serializes [module] for the Hive sync queue.
String syncModuleTypeToString(SyncModuleType module) => module.name;
