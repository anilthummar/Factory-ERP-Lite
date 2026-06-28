import 'package:hive_ce/hive_ce.dart';

import '../../../core/domain/entities/labor_entity.dart';
import '../../../core/domain/sync_metadata_keys.dart';
import '../../../core/enums/sync_status.dart';
import '../../../core/sync/sync_module_type.dart';
import '../../hive/hive_manager.dart';
import '../../../modules/labor_management/model/local/labor_hive_model.dart';
import 'sync_module_handler.dart';

/// Sync handler for labor management records.
class LaborSyncModuleHandler implements SyncModuleHandler {
  /// Creates [LaborSyncModuleHandler].
  LaborSyncModuleHandler({HiveManager? hiveManager})
      : _hiveManager = hiveManager ?? HiveManager.instance;

  final HiveManager _hiveManager;

  @override
  SyncModuleType get moduleType => SyncModuleType.laborManagement;

  Box<LaborHiveModel> get _box => _hiveManager.laborBox;

  @override
  Future<Map<String, dynamic>?> loadPayload(String recordId) async {
    final LaborHiveModel? model = _box.get(recordId);
    if (model == null) {
      return null;
    }

    final LaborEntity labor = model.toEntity();
    return <String, dynamic>{
      SyncMetadataKeys.id: labor.id,
      SyncMetadataKeys.createdAt: labor.createdAt.toIso8601String(),
      SyncMetadataKeys.updatedAt: labor.updatedAt.toIso8601String(),
      SyncMetadataKeys.syncStatus: syncStatusToString(labor.syncStatus),
      'name': labor.name,
      'mobile': labor.mobile,
      'skill': labor.skill,
      'dailyWage': labor.dailyWage,
      if (labor.notes != null) 'notes': labor.notes,
    };
  }

  @override
  Future<void> updateRecordSyncStatus(
    String recordId,
    SyncStatus status,
  ) async {
    final LaborHiveModel? model = _box.get(recordId);
    if (model == null) {
      return;
    }

    final LaborEntity labor = model.toEntity();
    await _box.put(
      recordId,
      LaborHiveModel.fromEntity(
        LaborEntity(
          id: labor.id,
          createdAt: labor.createdAt,
          updatedAt: DateTime.now(),
          syncStatus: status,
          name: labor.name,
          mobile: labor.mobile,
          skill: labor.skill,
          dailyWage: labor.dailyWage,
          notes: labor.notes,
        ),
      ),
    );
  }

  @override
  Future<void> applyRemotePayload(Map<String, dynamic> payload) async {
    final String id = payload[SyncMetadataKeys.id] as String;
    final LaborEntity labor = LaborEntity(
      id: id,
      createdAt: DateTime.parse(payload[SyncMetadataKeys.createdAt] as String),
      updatedAt: DateTime.parse(payload[SyncMetadataKeys.updatedAt] as String),
      syncStatus: SyncStatus.synced,
      name: payload['name'] as String,
      mobile: payload['mobile'] as String,
      skill: payload['skill'] as String,
      dailyWage: (payload['dailyWage'] as num).toDouble(),
      notes: payload['notes'] as String?,
    );
    await _box.put(id, LaborHiveModel.fromEntity(labor));
  }
}
