import 'package:hive_ce/hive_ce.dart';

import '../../attachments/model/local/attachment_hive_model.dart';
import '../../expense/model/local/expense_hive_model.dart';
import '../../factory_status/model/local/factory_status_hive_model.dart';
import '../../labor_management/model/local/labor_hive_model.dart';
import '../../person_management/model/local/person_hive_model.dart';
import '../../recurring_expenses/model/local/recurring_expense_hive_model.dart';
import '../../../service/hive/hive_box_names.dart';
import '../../../service/hive/hive_manager.dart';
import '../service/hive_backup_codec.dart';

/// Reads and writes Hive module data for backup/restore.
abstract class BackupLocalDataSource {
  /// Exports all ERP module boxes as JSON-safe maps keyed by box name.
  Future<Map<String, dynamic>> exportAllModules();

  /// Restores ERP module boxes from [modules] payload.
  Future<void> restoreAllModules(Map<String, dynamic> modules);

  /// Returns record counts per module box.
  Future<Map<String, int>> recordCounts();
}

/// Hive-backed implementation of [BackupLocalDataSource].
class BackupLocalDataSourceImpl implements BackupLocalDataSource {
  /// Creates [BackupLocalDataSourceImpl].
  BackupLocalDataSourceImpl({required HiveManager hiveManager})
      : _hiveManager = hiveManager;

  final HiveManager _hiveManager;

  static const List<String> _expenseBoxes = <String>[
    HiveBoxNames.materialPurchases,
    HiveBoxNames.truckExpenses,
    HiveBoxNames.maintenanceExpenses,
    HiveBoxNames.electricityExpenses,
    HiveBoxNames.miscellaneousExpenses,
  ];

  static const List<String> _mapBoxes = <String>[
    HiveBoxNames.calendarManagement,
    HiveBoxNames.reportsAnalytics,
  ];

  @override
  Future<Map<String, dynamic>> exportAllModules() async {
    final Map<String, dynamic> modules = <String, dynamic>{
      HiveBoxNames.personManagement: _hiveManager.personBox.values
          .map(HiveBackupCodec.personToMap)
          .toList(growable: false),
      HiveBoxNames.laborManagement: _hiveManager.laborBox.values
          .map(HiveBackupCodec.laborToMap)
          .toList(growable: false),
      HiveBoxNames.materialPurchases: _hiveManager.materialPurchaseBox.values
          .map(HiveBackupCodec.expenseToMap)
          .toList(growable: false),
      HiveBoxNames.truckExpenses: _hiveManager.truckExpenseBox.values
          .map(HiveBackupCodec.expenseToMap)
          .toList(growable: false),
      HiveBoxNames.maintenanceExpenses: _hiveManager
          .maintenanceExpenseBox.values
          .map(HiveBackupCodec.expenseToMap)
          .toList(growable: false),
      HiveBoxNames.electricityExpenses: _hiveManager
          .electricityExpenseBox.values
          .map(HiveBackupCodec.expenseToMap)
          .toList(growable: false),
      HiveBoxNames.miscellaneousExpenses: _hiveManager
          .miscellaneousExpenseBox.values
          .map(HiveBackupCodec.expenseToMap)
          .toList(growable: false),
      HiveBoxNames.recurringExpenses: _hiveManager.recurringExpenseBox.values
          .map(HiveBackupCodec.recurringExpenseToMap)
          .toList(growable: false),
      HiveBoxNames.factoryStatus: _hiveManager.factoryStatusBox.values
          .map(HiveBackupCodec.factoryStatusToMap)
          .toList(growable: false),
      HiveBoxNames.attachments: _hiveManager.attachmentsBox.values
          .map(HiveBackupCodec.attachmentToMap)
          .toList(growable: false),
    };

    for (final String boxName in _mapBoxes) {
      if (_hiveManager.moduleBox(boxName).isNotEmpty) {
        modules[boxName] = HiveBackupCodec.mapBoxToList(
          Map<dynamic, dynamic>.from(_hiveManager.moduleBox(boxName).toMap()),
        );
      }
    }

    if (_hiveManager.meta.isNotEmpty) {
      modules[HiveBoxNames.meta] = HiveBackupCodec.mapBoxToList(
        Map<dynamic, dynamic>.from(_hiveManager.meta.toMap()),
      );
    }

    return modules;
  }

  @override
  Future<void> restoreAllModules(Map<String, dynamic> modules) async {
    await _restorePersons(modules);
    await _restoreLabor(modules);
    await _restoreExpenses(modules);
    await _restoreRecurringExpenses(modules);
    await _restoreFactoryStatus(modules);
    await _restoreAttachments(modules);
    await _restoreMapBoxes(modules);
  }

  @override
  Future<Map<String, int>> recordCounts() async {
    return <String, int>{
      HiveBoxNames.personManagement: _hiveManager.personBox.length,
      HiveBoxNames.laborManagement: _hiveManager.laborBox.length,
      HiveBoxNames.materialPurchases: _hiveManager.materialPurchaseBox.length,
      HiveBoxNames.truckExpenses: _hiveManager.truckExpenseBox.length,
      HiveBoxNames.maintenanceExpenses:
          _hiveManager.maintenanceExpenseBox.length,
      HiveBoxNames.electricityExpenses:
          _hiveManager.electricityExpenseBox.length,
      HiveBoxNames.miscellaneousExpenses:
          _hiveManager.miscellaneousExpenseBox.length,
      HiveBoxNames.recurringExpenses: _hiveManager.recurringExpenseBox.length,
      HiveBoxNames.factoryStatus: _hiveManager.factoryStatusBox.length,
      HiveBoxNames.attachments: _hiveManager.attachmentsBox.length,
      for (final String boxName in _mapBoxes)
        boxName: _hiveManager.moduleBox(boxName).length,
    };
  }

  Future<void> _restorePersons(Map<String, dynamic> modules) async {
    final List<dynamic>? raw =
        modules[HiveBoxNames.personManagement] as List<dynamic>?;
    if (raw == null) {
      return;
    }

    await _hiveManager.personBox.clear();
    for (final dynamic entry in raw) {
      final PersonHiveModel model = HiveBackupCodec.personFromMap(
        Map<String, dynamic>.from(entry as Map<dynamic, dynamic>),
      );
      await _hiveManager.personBox.put(model.id, model);
    }
  }

  Future<void> _restoreLabor(Map<String, dynamic> modules) async {
    final List<dynamic>? raw =
        modules[HiveBoxNames.laborManagement] as List<dynamic>?;
    if (raw == null) {
      return;
    }

    await _hiveManager.laborBox.clear();
    for (final dynamic entry in raw) {
      final LaborHiveModel model = HiveBackupCodec.laborFromMap(
        Map<String, dynamic>.from(entry as Map<dynamic, dynamic>),
      );
      await _hiveManager.laborBox.put(model.id, model);
    }
  }

  Future<void> _restoreExpenses(Map<String, dynamic> modules) async {
    for (final String boxName in _expenseBoxes) {
      final List<dynamic>? raw = modules[boxName] as List<dynamic>?;
      if (raw == null) {
        continue;
      }

      final Box<ExpenseHiveModel> box = _expenseBox(boxName);
      await box.clear();
      for (final dynamic entry in raw) {
        final ExpenseHiveModel model = HiveBackupCodec.expenseFromMap(
          Map<String, dynamic>.from(entry as Map<dynamic, dynamic>),
        );
        await box.put(model.id, model);
      }
    }
  }

  Box<ExpenseHiveModel> _expenseBox(String boxName) {
    return switch (boxName) {
      HiveBoxNames.materialPurchases => _hiveManager.materialPurchaseBox,
      HiveBoxNames.truckExpenses => _hiveManager.truckExpenseBox,
      HiveBoxNames.maintenanceExpenses => _hiveManager.maintenanceExpenseBox,
      HiveBoxNames.electricityExpenses => _hiveManager.electricityExpenseBox,
      HiveBoxNames.miscellaneousExpenses =>
        _hiveManager.miscellaneousExpenseBox,
      _ => throw ArgumentError('Unknown expense box: $boxName'),
    };
  }

  Future<void> _restoreRecurringExpenses(Map<String, dynamic> modules) async {
    final List<dynamic>? raw =
        modules[HiveBoxNames.recurringExpenses] as List<dynamic>?;
    if (raw == null) {
      return;
    }

    await _hiveManager.recurringExpenseBox.clear();
    for (final dynamic entry in raw) {
      final RecurringExpenseHiveModel model =
          HiveBackupCodec.recurringExpenseFromMap(
        Map<String, dynamic>.from(entry as Map<dynamic, dynamic>),
      );
      await _hiveManager.recurringExpenseBox.put(model.id, model);
    }
  }

  Future<void> _restoreFactoryStatus(Map<String, dynamic> modules) async {
    final List<dynamic>? raw =
        modules[HiveBoxNames.factoryStatus] as List<dynamic>?;
    if (raw == null) {
      return;
    }

    await _hiveManager.factoryStatusBox.clear();
    for (final dynamic entry in raw) {
      final FactoryStatusHiveModel model = HiveBackupCodec.factoryStatusFromMap(
        Map<String, dynamic>.from(entry as Map<dynamic, dynamic>),
      );
      await _hiveManager.factoryStatusBox.put(model.id, model);
    }
  }

  Future<void> _restoreAttachments(Map<String, dynamic> modules) async {
    final List<dynamic>? raw =
        modules[HiveBoxNames.attachments] as List<dynamic>?;
    if (raw == null) {
      return;
    }

    await _hiveManager.attachmentsBox.clear();
    for (final dynamic entry in raw) {
      final AttachmentHiveModel model = HiveBackupCodec.attachmentFromMap(
        Map<String, dynamic>.from(entry as Map<dynamic, dynamic>),
      );
      await _hiveManager.attachmentsBox.put(model.id, model);
    }
  }

  Future<void> _restoreMapBoxes(Map<String, dynamic> modules) async {
    for (final String boxName in <String>[
      ..._mapBoxes,
      HiveBoxNames.meta,
    ]) {
      final List<dynamic>? raw = modules[boxName] as List<dynamic>?;
      if (raw == null) {
        continue;
      }

      final Box<Map<dynamic, dynamic>> box = _hiveManager.moduleBox(boxName);
      await box.clear();
      final Map<dynamic, dynamic> restored =
          HiveBackupCodec.mapListToBox(raw);
      for (final MapEntry<dynamic, dynamic> entry in restored.entries) {
        await box.put(entry.key, entry.value);
      }
    }
  }
}
