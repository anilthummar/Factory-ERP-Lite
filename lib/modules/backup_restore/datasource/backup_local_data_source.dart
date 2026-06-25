import 'package:hive_ce/hive_ce.dart';

import '../../../service/hive/hive_box_names.dart';
import '../../../service/hive/hive_manager.dart';
import '../../expense/model/local/expense_hive_model.dart';
import '../../factory_status/model/local/factory_status_hive_model.dart';
import '../../labor_management/model/local/labor_hive_model.dart';
import '../../person_management/model/local/person_hive_model.dart';
import '../../recurring_expenses/model/local/recurring_expense_hive_model.dart';
import '../domain/models/backup_progress.dart';
import '../service/hive_backup_codec.dart';

/// Callback for reporting backup/restore progress.
typedef BackupProgressCallback = void Function(BackupProgress progress);

/// Reads and writes Hive module data for backup/restore.
abstract class BackupLocalDataSource {
  /// Exports supported ERP module boxes as JSON-safe maps keyed by box name.
  Future<Map<String, dynamic>> exportModules();

  /// Restores supported ERP module boxes from [modules] payload.
  Future<void> restoreModules(
    Map<String, dynamic> modules, {
    BackupProgressCallback? onProgress,
  });

  /// Returns record counts per supported module box.
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

  @override
  Future<Map<String, dynamic>> exportModules() async {
    return <String, dynamic>{
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
      HiveBoxNames.calendarManagement: _hiveManager
              .moduleBox(HiveBoxNames.calendarManagement)
              .isEmpty
          ? <Map<String, dynamic>>[]
          : HiveBackupCodec.mapBoxToList(
              Map<dynamic, dynamic>.from(
                _hiveManager
                    .moduleBox(HiveBoxNames.calendarManagement)
                    .toMap(),
              ),
            ),
    };
  }

  @override
  Future<void> restoreModules(
    Map<String, dynamic> modules, {
    BackupProgressCallback? onProgress,
  }) async {
    final List<String> stages = <String>[
      HiveBoxNames.personManagement,
      HiveBoxNames.laborManagement,
      ..._expenseBoxes,
      HiveBoxNames.recurringExpenses,
      HiveBoxNames.factoryStatus,
      HiveBoxNames.calendarManagement,
    ];
    final int total = stages.length;
    int step = 0;

    void report(String stage, String moduleKey) {
      onProgress?.call(
        BackupProgress(
          stage: stage,
          completedSteps: step,
          totalSteps: total,
          moduleKey: moduleKey,
        ),
      );
    }

    report('Restoring persons', HiveBoxNames.personManagement);
    await _restorePersons(modules);
    step++;

    report('Restoring labor', HiveBoxNames.laborManagement);
    await _restoreLabor(modules);
    step++;

    for (final String boxName in _expenseBoxes) {
      report('Restoring expenses', boxName);
      await _restoreExpenseBox(modules, boxName);
      step++;
    }

    report('Restoring recurring expenses', HiveBoxNames.recurringExpenses);
    await _restoreRecurringExpenses(modules);
    step++;

    report('Restoring factory status', HiveBoxNames.factoryStatus);
    await _restoreFactoryStatus(modules);
    step++;

    report('Restoring calendar events', HiveBoxNames.calendarManagement);
    await _restoreCalendarEvents(modules);
    step++;

    onProgress?.call(
      BackupProgress(
        stage: 'Restore complete',
        completedSteps: total,
        totalSteps: total,
      ),
    );
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
      HiveBoxNames.calendarManagement: _hiveManager
          .moduleBox(HiveBoxNames.calendarManagement)
          .length,
    };
  }

  Future<void> _restorePersons(Map<String, dynamic> modules) async {
    final List<dynamic>? raw =
        modules[HiveBoxNames.personManagement] as List<dynamic>?;
    await _hiveManager.personBox.clear();
    if (raw == null) {
      return;
    }

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
    await _hiveManager.laborBox.clear();
    if (raw == null) {
      return;
    }

    for (final dynamic entry in raw) {
      final LaborHiveModel model = HiveBackupCodec.laborFromMap(
        Map<String, dynamic>.from(entry as Map<dynamic, dynamic>),
      );
      await _hiveManager.laborBox.put(model.id, model);
    }
  }

  Future<void> _restoreExpenseBox(
    Map<String, dynamic> modules,
    String boxName,
  ) async {
    final List<dynamic>? raw = modules[boxName] as List<dynamic>?;
    final Box<ExpenseHiveModel> box = _expenseBox(boxName);
    await box.clear();
    if (raw == null) {
      return;
    }

    for (final dynamic entry in raw) {
      final ExpenseHiveModel model = HiveBackupCodec.expenseFromMap(
        Map<String, dynamic>.from(entry as Map<dynamic, dynamic>),
      );
      await box.put(model.id, model);
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
    await _hiveManager.recurringExpenseBox.clear();
    if (raw == null) {
      return;
    }

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
    await _hiveManager.factoryStatusBox.clear();
    if (raw == null) {
      return;
    }

    for (final dynamic entry in raw) {
      final FactoryStatusHiveModel model = HiveBackupCodec.factoryStatusFromMap(
        Map<String, dynamic>.from(entry as Map<dynamic, dynamic>),
      );
      await _hiveManager.factoryStatusBox.put(model.id, model);
    }
  }

  Future<void> _restoreCalendarEvents(Map<String, dynamic> modules) async {
    final List<dynamic>? raw =
        modules[HiveBoxNames.calendarManagement] as List<dynamic>?;
    final Box<Map<dynamic, dynamic>> box =
        _hiveManager.moduleBox(HiveBoxNames.calendarManagement);
    await box.clear();
    if (raw == null) {
      return;
    }

    final Map<dynamic, dynamic> restored = HiveBackupCodec.mapListToBox(raw);
    for (final MapEntry<dynamic, dynamic> entry in restored.entries) {
      await box.put(entry.key, entry.value);
    }
  }
}
