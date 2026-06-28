import 'package:hive_ce/hive_ce.dart';

import '../../../core/domain/entities/recurring_expense_entity.dart';
import '../../../core/domain/enums/recurring_expense_frequency.dart';
import '../../../core/domain/sync_metadata_keys.dart';
import '../../../core/enums/sync_status.dart';
import '../../../core/sync/sync_module_type.dart';
import '../../hive/hive_manager.dart';
import '../../../modules/recurring_expenses/model/local/recurring_expense_hive_model.dart';
import 'sync_module_handler.dart';

/// Sync handler for recurring expense records.
class RecurringExpenseSyncModuleHandler implements SyncModuleHandler {
  /// Creates [RecurringExpenseSyncModuleHandler].
  RecurringExpenseSyncModuleHandler({HiveManager? hiveManager})
      : _hiveManager = hiveManager ?? HiveManager.instance;

  final HiveManager _hiveManager;

  @override
  SyncModuleType get moduleType => SyncModuleType.recurringExpenses;

  Box<RecurringExpenseHiveModel> get _box => _hiveManager.recurringExpenseBox;

  @override
  Future<Map<String, dynamic>?> loadPayload(String recordId) async {
    final RecurringExpenseHiveModel? model = _box.get(recordId);
    if (model == null) {
      return null;
    }

    final RecurringExpenseEntity expense = model.toEntity();
    return <String, dynamic>{
      SyncMetadataKeys.id: expense.id,
      SyncMetadataKeys.createdAt: expense.createdAt.toIso8601String(),
      SyncMetadataKeys.updatedAt: expense.updatedAt.toIso8601String(),
      SyncMetadataKeys.syncStatus: syncStatusToString(expense.syncStatus),
      'title': expense.title,
      'amount': expense.amount,
      'frequency': expense.frequency.name,
      'startDate': expense.startDate.toIso8601String(),
      if (expense.endDate != null)
        'endDate': expense.endDate!.toIso8601String(),
      if (expense.notes != null) 'notes': expense.notes,
    };
  }

  @override
  Future<void> updateRecordSyncStatus(
    String recordId,
    SyncStatus status,
  ) async {
    final RecurringExpenseHiveModel? model = _box.get(recordId);
    if (model == null) {
      return;
    }

    final RecurringExpenseEntity expense = model.toEntity();
    await _box.put(
      recordId,
      RecurringExpenseHiveModel.fromEntity(
        RecurringExpenseEntity(
          id: expense.id,
          createdAt: expense.createdAt,
          updatedAt: DateTime.now(),
          syncStatus: status,
          title: expense.title,
          amount: expense.amount,
          frequency: expense.frequency,
          startDate: expense.startDate,
          endDate: expense.endDate,
          notes: expense.notes,
        ),
      ),
    );
  }

  @override
  Future<void> applyRemotePayload(Map<String, dynamic> payload) async {
    final String id = payload[SyncMetadataKeys.id] as String;
    final RecurringExpenseEntity expense = RecurringExpenseEntity(
      id: id,
      createdAt: DateTime.parse(payload[SyncMetadataKeys.createdAt] as String),
      updatedAt: DateTime.parse(payload[SyncMetadataKeys.updatedAt] as String),
      syncStatus: SyncStatus.synced,
      title: payload['title'] as String,
      amount: (payload['amount'] as num).toDouble(),
      frequency: RecurringExpenseFrequency.values.byName(
        payload['frequency'] as String,
      ),
      startDate: DateTime.parse(payload['startDate'] as String),
      endDate: payload['endDate'] == null
          ? null
          : DateTime.parse(payload['endDate'] as String),
      notes: payload['notes'] as String?,
    );
    await _box.put(id, RecurringExpenseHiveModel.fromEntity(expense));
  }
}
