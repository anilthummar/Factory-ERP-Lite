import 'package:hive_ce/hive_ce.dart';

import '../../../core/domain/entities/expense_entity.dart';
import '../../../core/domain/enums/expense_category.dart';
import '../../../core/domain/sync_metadata_keys.dart';
import '../../../core/enums/sync_status.dart';
import '../../../core/sync/sync_module_type.dart';
import '../../../modules/expense/foundation/expense_module_config.dart';
import '../../../modules/expense/model/local/expense_hive_model.dart';
import '../../hive/hive_manager.dart';
import 'sync_module_handler.dart';

/// Sync handler for module-scoped one-time expense records.
class ExpenseSyncModuleHandler implements SyncModuleHandler {
  /// Creates [ExpenseSyncModuleHandler].
  ExpenseSyncModuleHandler({
    required SyncModuleType moduleType,
    required ExpenseModuleConfig config,
    HiveManager? hiveManager,
  })  : _moduleType = moduleType,
        _config = config,
        _hiveManager = hiveManager ?? HiveManager.instance;

  final SyncModuleType _moduleType;
  final ExpenseModuleConfig _config;
  final HiveManager _hiveManager;

  @override
  SyncModuleType get moduleType => _moduleType;

  Box<ExpenseHiveModel> get _box => _config.boxAccessor(_hiveManager);

  @override
  Future<Map<String, dynamic>?> loadPayload(String recordId) async {
    final ExpenseHiveModel? model = _box.get(recordId);
    if (model == null) {
      return null;
    }

    final ExpenseEntity expense = model.toEntity();
    return <String, dynamic>{
      SyncMetadataKeys.id: expense.id,
      SyncMetadataKeys.createdAt: expense.createdAt.toIso8601String(),
      SyncMetadataKeys.updatedAt: expense.updatedAt.toIso8601String(),
      SyncMetadataKeys.syncStatus: syncStatusToString(expense.syncStatus),
      'title': expense.title,
      'amount': expense.amount,
      'date': expense.date.toIso8601String(),
      'category': expense.category.name,
      if (expense.notes != null) 'notes': expense.notes,
      if (expense.attachmentPath != null)
        'attachmentPath': expense.attachmentPath,
    };
  }

  @override
  Future<void> updateRecordSyncStatus(
    String recordId,
    SyncStatus status,
  ) async {
    final ExpenseHiveModel? model = _box.get(recordId);
    if (model == null) {
      return;
    }

    final ExpenseEntity expense = model.toEntity();
    await _box.put(
      recordId,
      ExpenseHiveModel.fromEntity(
        ExpenseEntity(
          id: expense.id,
          createdAt: expense.createdAt,
          updatedAt: DateTime.now(),
          syncStatus: status,
          title: expense.title,
          amount: expense.amount,
          date: expense.date,
          category: expense.category,
          notes: expense.notes,
          attachmentPath: expense.attachmentPath,
        ),
      ),
    );
  }

  @override
  Future<void> applyRemotePayload(Map<String, dynamic> payload) async {
    final String id = payload[SyncMetadataKeys.id] as String;
    final ExpenseEntity expense = ExpenseEntity(
      id: id,
      createdAt: DateTime.parse(payload[SyncMetadataKeys.createdAt] as String),
      updatedAt: DateTime.parse(payload[SyncMetadataKeys.updatedAt] as String),
      syncStatus: SyncStatus.synced,
      title: payload['title'] as String,
      amount: (payload['amount'] as num).toDouble(),
      date: DateTime.parse(payload['date'] as String),
      category: ExpenseCategory.values.byName(payload['category'] as String),
      notes: payload['notes'] as String?,
      attachmentPath: payload['attachmentPath'] as String?,
    );
    await _box.put(id, ExpenseHiveModel.fromEntity(expense));
  }
}
