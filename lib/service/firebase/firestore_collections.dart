/// Firestore collection paths for Factory ERP Lite.
///
/// Documents include a `factoryId` field for multi-factory support.
///
/// Logical name aliases (user-facing / docs):
/// - persons → [personManagement]
/// - labors → [laborManagement]
/// - expenses → material/truck/maintenance/electricity/misc collections
/// - calendar_events → [calendarManagement]
abstract final class FirestoreCollections {
  static const String factories = 'factories';
  static const String users = 'users';

  /// System metadata collection for health probes.
  static const String systemMeta = '_meta';

  /// Health probe document under [systemMeta].
  static const String healthProbeDoc = 'health_probe';

  /// Sentinel document id that bootstraps a module collection.
  static const String bootstrapDocId = '_bootstrap';

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

  /// Collections bootstrapped on first authenticated health check.
  static const List<String> bootstrapCollections = <String>[
    personManagement,
    laborManagement,
    materialPurchases,
    truckExpenses,
    maintenanceExpenses,
    electricityExpenses,
    miscellaneousExpenses,
    recurringExpenses,
    factoryStatus,
    calendarManagement,
    attachments,
  ];

  /// All ERP module collections synced from Hive.
  static const List<String> moduleCollections = <String>[
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
