/// Hive box names — one box per ERP module for offline-first storage.
abstract final class HiveBoxNames {
  static const String syncQueue = 'sync_queue';
  static const String meta = 'meta';

  static const String laborManagement = 'labor_management';
  static const String personManagement = 'person_management';
  static const String truckExpenses = 'truck_expenses';
  static const String maintenanceExpenses = 'maintenance_expenses';
  static const String electricityExpenses = 'electricity_expenses';
  static const String materialPurchases = 'material_purchases';
  static const String miscellaneousExpenses = 'miscellaneous_expenses';
  static const String calendarManagement = 'calendar_management';
  static const String factoryStatus = 'factory_status';
  static const String reportsAnalytics = 'reports_analytics';
  static const String attachments = 'attachments';
  static const String recurringExpenses = 'recurring_expenses';

  /// All module boxes opened during app bootstrap.
  static const List<String> moduleBoxes = <String>[
    laborManagement,
    personManagement,
    truckExpenses,
    maintenanceExpenses,
    electricityExpenses,
    materialPurchases,
    miscellaneousExpenses,
    calendarManagement,
    factoryStatus,
    reportsAnalytics,
    attachments,
    recurringExpenses,
  ];
}
