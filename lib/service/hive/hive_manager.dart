import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../../core/hive/hive_type_ids.dart';
import '../../modules/expense/model/local/expense_hive_model.dart';
import '../../modules/factory_status/model/local/factory_status_hive_model.dart';
import '../../modules/attachments/model/local/attachment_hive_model.dart';
import '../../modules/labor_management/model/local/labor_hive_model.dart';
import '../../modules/person_management/model/local/person_hive_model.dart';
import '../../modules/recurring_expenses/model/local/recurring_expense_hive_model.dart';
import 'hive_box_names.dart';

/// Initializes Hive and provides access to offline-first module boxes.
class HiveManager {
  HiveManager._();

  static final HiveManager instance = HiveManager._();

  bool _initialized = false;

  static const Set<String> _typedBoxes = <String>{
    HiveBoxNames.personManagement,
    HiveBoxNames.laborManagement,
    HiveBoxNames.materialPurchases,
    HiveBoxNames.truckExpenses,
    HiveBoxNames.maintenanceExpenses,
    HiveBoxNames.electricityExpenses,
    HiveBoxNames.miscellaneousExpenses,
    HiveBoxNames.recurringExpenses,
    HiveBoxNames.factoryStatus,
    HiveBoxNames.attachments,
  };

  static const List<String> _expenseModuleBoxNames = <String>[
    HiveBoxNames.materialPurchases,
    HiveBoxNames.truckExpenses,
    HiveBoxNames.maintenanceExpenses,
    HiveBoxNames.electricityExpenses,
    HiveBoxNames.miscellaneousExpenses,
  ];

  /// Whether [init] has completed successfully.
  bool get isInitialized => _initialized;

  /// Initializes Hive and opens foundation + module boxes.
  Future<void> init() async {
    if (_initialized) {
      return;
    }

    await Hive.initFlutter();
    _registerAdapters();
    await _openMapBox(HiveBoxNames.syncQueue);
    await _openMapBox(HiveBoxNames.meta);
    await _openPersonBox();
    await _openLaborBox();
    await _openExpenseModuleBoxes();
    await _openRecurringExpenseBox();
    await _openFactoryStatusBox();
    await _openAttachmentsBox();

    for (final String boxName in HiveBoxNames.moduleBoxes) {
      if (_typedBoxes.contains(boxName)) {
        continue;
      }
      await _openMapBox(boxName);
    }

    _initialized = true;
  }

  /// Opens sync/meta boxes and typed boxes needed by module tests.
  @visibleForTesting
  Future<void> initForTests(String storagePath) async {
    if (_initialized) {
      return;
    }

    Hive.init(storagePath);
    _registerAdapters();
    await _openMapBox(HiveBoxNames.syncQueue);
    await _openMapBox(HiveBoxNames.meta);
    await _openFactoryStatusBox();
    await _openAttachmentsBox();
    _initialized = true;
  }

  /// Whether the typed person box is open.
  bool get isPersonBoxOpen => Hive.isBoxOpen(HiveBoxNames.personManagement);

  /// Typed Hive box for person records.
  Box<PersonHiveModel> get personBox =>
      Hive.box<PersonHiveModel>(HiveBoxNames.personManagement);

  /// Whether the typed labor box is open.
  bool get isLaborBoxOpen => Hive.isBoxOpen(HiveBoxNames.laborManagement);

  /// Typed Hive box for labor records.
  Box<LaborHiveModel> get laborBox =>
      Hive.box<LaborHiveModel>(HiveBoxNames.laborManagement);

  /// Whether the material purchase expense box is open.
  bool get isMaterialPurchaseBoxOpen =>
      Hive.isBoxOpen(HiveBoxNames.materialPurchases);

  /// Typed Hive box for material purchase expenses.
  Box<ExpenseHiveModel> get materialPurchaseBox =>
      Hive.box<ExpenseHiveModel>(HiveBoxNames.materialPurchases);

  /// Whether the truck expense box is open.
  bool get isTruckExpenseBoxOpen =>
      Hive.isBoxOpen(HiveBoxNames.truckExpenses);

  /// Typed Hive box for truck expenses.
  Box<ExpenseHiveModel> get truckExpenseBox =>
      Hive.box<ExpenseHiveModel>(HiveBoxNames.truckExpenses);

  /// Whether the maintenance expense box is open.
  bool get isMaintenanceExpenseBoxOpen =>
      Hive.isBoxOpen(HiveBoxNames.maintenanceExpenses);

  /// Typed Hive box for maintenance expenses.
  Box<ExpenseHiveModel> get maintenanceExpenseBox =>
      Hive.box<ExpenseHiveModel>(HiveBoxNames.maintenanceExpenses);

  /// Whether the electricity expense box is open.
  bool get isElectricityExpenseBoxOpen =>
      Hive.isBoxOpen(HiveBoxNames.electricityExpenses);

  /// Typed Hive box for electricity expenses.
  Box<ExpenseHiveModel> get electricityExpenseBox =>
      Hive.box<ExpenseHiveModel>(HiveBoxNames.electricityExpenses);

  /// Whether the miscellaneous expense box is open.
  bool get isMiscellaneousExpenseBoxOpen =>
      Hive.isBoxOpen(HiveBoxNames.miscellaneousExpenses);

  /// Typed Hive box for miscellaneous expenses.
  Box<ExpenseHiveModel> get miscellaneousExpenseBox =>
      Hive.box<ExpenseHiveModel>(HiveBoxNames.miscellaneousExpenses);

  /// Whether the typed recurring expense box is open.
  bool get isRecurringExpenseBoxOpen =>
      Hive.isBoxOpen(HiveBoxNames.recurringExpenses);

  /// Typed Hive box for recurring expense records.
  Box<RecurringExpenseHiveModel> get recurringExpenseBox =>
      Hive.box<RecurringExpenseHiveModel>(HiveBoxNames.recurringExpenses);

  /// Whether the typed factory status box is open.
  bool get isFactoryStatusBoxOpen =>
      Hive.isBoxOpen(HiveBoxNames.factoryStatus);

  /// Typed Hive box for factory status history records.
  Box<FactoryStatusHiveModel> get factoryStatusBox =>
      Hive.box<FactoryStatusHiveModel>(HiveBoxNames.factoryStatus);

  /// Whether the typed attachments box is open.
  bool get isAttachmentsBoxOpen => Hive.isBoxOpen(HiveBoxNames.attachments);

  /// Typed Hive box for attachment metadata records.
  Box<AttachmentHiveModel> get attachmentsBox =>
      Hive.box<AttachmentHiveModel>(HiveBoxNames.attachments);

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
    if (!Hive.isAdapterRegistered(HiveTypeIds.attachmentHiveModel)) {
      Hive.registerAdapter(AttachmentHiveModelAdapter());
    }
  }

  Future<void> _openPersonBox() async {
    if (!Hive.isBoxOpen(HiveBoxNames.personManagement)) {
      await Hive.openBox<PersonHiveModel>(HiveBoxNames.personManagement);
    }
  }

  Future<void> _openLaborBox() async {
    if (!Hive.isBoxOpen(HiveBoxNames.laborManagement)) {
      await Hive.openBox<LaborHiveModel>(HiveBoxNames.laborManagement);
    }
  }

  Future<void> _openExpenseModuleBoxes() async {
    for (final String boxName in _expenseModuleBoxNames) {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox<ExpenseHiveModel>(boxName);
      }
    }
  }

  Future<void> _openRecurringExpenseBox() async {
    if (!Hive.isBoxOpen(HiveBoxNames.recurringExpenses)) {
      await Hive.openBox<RecurringExpenseHiveModel>(
        HiveBoxNames.recurringExpenses,
      );
    }
  }

  Future<void> _openFactoryStatusBox() async {
    if (!Hive.isBoxOpen(HiveBoxNames.factoryStatus)) {
      await Hive.openBox<FactoryStatusHiveModel>(HiveBoxNames.factoryStatus);
    }
  }

  Future<void> _openAttachmentsBox() async {
    if (!Hive.isBoxOpen(HiveBoxNames.attachments)) {
      await Hive.openBox<AttachmentHiveModel>(HiveBoxNames.attachments);
    }
  }

  Future<void> _openMapBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<Map<dynamic, dynamic>>(boxName);
    }
  }
}
