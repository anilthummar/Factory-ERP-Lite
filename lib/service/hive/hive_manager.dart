import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../../core/hive/hive_type_ids.dart';
import '../../modules/expense/model/local/expense_hive_model.dart';
import '../../modules/factory_status/model/local/factory_status_hive_model.dart';
import '../../modules/labor_management/model/local/labor_hive_model.dart';
import '../../modules/person_management/model/local/person_hive_model.dart';
import '../../modules/recurring_expenses/model/local/recurring_expense_hive_model.dart';
import 'hive_box_names.dart';

/// Initializes Hive and provides access to offline-first module boxes.
class HiveManager {
  HiveManager._();

  static final HiveManager instance = HiveManager._();

  bool _initialized = false;

  /// Whether [init] has completed successfully.
  bool get isInitialized => _initialized;

  /// Initializes Hive and opens foundation + module boxes.
  Future<void> init() async {
    if (_initialized) {
      return;
    }

    await Hive.initFlutter();
    _registerAdapters();
    await _openBox(HiveBoxNames.syncQueue);
    await _openBox(HiveBoxNames.meta);

    for (final String boxName in HiveBoxNames.moduleBoxes) {
      await _openBox(boxName);
    }

    _initialized = true;
  }

  /// Pending sync operations queue (maps until typed adapters are added).
  Box<Map<dynamic, dynamic>> get syncQueue =>
      Hive.box<Map<dynamic, dynamic>>(HiveBoxNames.syncQueue);

  /// App-level Hive metadata (last sync timestamps, schema version, etc.).
  Box<Map<dynamic, dynamic>> get meta =>
      Hive.box<Map<dynamic, dynamic>>(HiveBoxNames.meta);

  /// Returns an opened module box by [boxName].
  Box<Map<dynamic, dynamic>> moduleBox(String boxName) =>
      Hive.box<Map<dynamic, dynamic>>(boxName);

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTypeIds.personHiveModel)) {
      Hive.registerAdapter(PersonHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTypeIds.laborHiveModel)) {
      Hive.registerAdapter(LaborHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTypeIds.expenseHiveModel)) {
      Hive.registerAdapter(ExpenseHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTypeIds.recurringExpenseHiveModel)) {
      Hive.registerAdapter(RecurringExpenseHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTypeIds.factoryStatusHiveModel)) {
      Hive.registerAdapter(FactoryStatusHiveModelAdapter());
    }
  }

  Future<void> _openBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<Map<dynamic, dynamic>>(boxName);
    }
  }
}
