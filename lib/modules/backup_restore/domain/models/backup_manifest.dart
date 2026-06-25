import '../../../../service/hive/hive_box_names.dart';

/// JSON backup format metadata and supported module keys.
abstract final class BackupManifest {
  /// Current backup file format version.
  static const int currentVersion = 1;

  /// Application identifier stored in backup files.
  static const String appId = 'factory_erp_lite';

  /// File extension for JSON backups.
  static const String fileExtension = 'json';

  /// Hive boxes included in local JSON backup/restore.
  static const List<String> supportedModuleKeys = <String>[
    HiveBoxNames.personManagement,
    HiveBoxNames.laborManagement,
    HiveBoxNames.materialPurchases,
    HiveBoxNames.truckExpenses,
    HiveBoxNames.maintenanceExpenses,
    HiveBoxNames.electricityExpenses,
    HiveBoxNames.miscellaneousExpenses,
    HiveBoxNames.recurringExpenses,
    HiveBoxNames.factoryStatus,
    HiveBoxNames.calendarManagement,
  ];

  /// Human-readable labels for UI and validation messages.
  static const Map<String, String> moduleLabels = <String, String>{
    HiveBoxNames.personManagement: 'Persons',
    HiveBoxNames.laborManagement: 'Labor',
    HiveBoxNames.materialPurchases: 'Material Purchases',
    HiveBoxNames.truckExpenses: 'Truck Expenses',
    HiveBoxNames.maintenanceExpenses: 'Maintenance Expenses',
    HiveBoxNames.electricityExpenses: 'Electricity Expenses',
    HiveBoxNames.miscellaneousExpenses: 'Miscellaneous Expenses',
    HiveBoxNames.recurringExpenses: 'Recurring Expenses',
    HiveBoxNames.factoryStatus: 'Factory Status',
    HiveBoxNames.calendarManagement: 'Calendar Events',
  };
}
