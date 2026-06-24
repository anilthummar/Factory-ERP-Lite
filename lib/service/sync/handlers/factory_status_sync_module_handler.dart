import 'package:hive_ce/hive_ce.dart';

import '../../../core/domain/entities/factory_status_entity.dart';
import '../../../core/domain/enums/factory_status_type.dart';
import '../../../core/domain/sync_metadata_keys.dart';
import '../../../core/enums/sync_status.dart';
import '../../../core/sync/sync_module_type.dart';
import '../../../modules/factory_status/model/local/factory_status_hive_model.dart';
import '../../hive/hive_manager.dart';
import 'sync_module_handler.dart';

/// Sync handler for factory status history records.
class FactoryStatusSyncModuleHandler implements SyncModuleHandler {
  /// Creates [FactoryStatusSyncModuleHandler].
  FactoryStatusSyncModuleHandler({HiveManager? hiveManager})
      : _hiveManager = hiveManager ?? HiveManager.instance;

  final HiveManager _hiveManager;

  @override
  SyncModuleType get moduleType => SyncModuleType.factoryStatus;

  Box<FactoryStatusHiveModel> get _box => _hiveManager.factoryStatusBox;

  @override
  Future<Map<String, dynamic>?> loadPayload(String recordId) async {
    final FactoryStatusHiveModel? model = _box.get(recordId);
    if (model == null) {
      return null;
    }

    final FactoryStatusEntity status = model.toEntity();
    return <String, dynamic>{
      SyncMetadataKeys.id: status.id,
      SyncMetadataKeys.createdAt: status.createdAt.toIso8601String(),
      SyncMetadataKeys.updatedAt: status.updatedAt.toIso8601String(),
      SyncMetadataKeys.syncStatus: syncStatusToString(status.syncStatus),
      'status': status.status.name,
      if (status.notes != null) 'notes': status.notes,
    };
  }

  @override
  Future<void> updateRecordSyncStatus(
    String recordId,
    SyncStatus status,
  ) async {
    final FactoryStatusHiveModel? model = _box.get(recordId);
    if (model == null) {
      return;
    }

    final FactoryStatusEntity entity = model.toEntity();
    await _box.put(
      recordId,
      FactoryStatusHiveModel.fromEntity(
        FactoryStatusEntity(
          id: entity.id,
          createdAt: entity.createdAt,
          updatedAt: DateTime.now(),
          syncStatus: status,
          status: entity.status,
          notes: entity.notes,
        ),
      ),
    );
  }

  @override
  Future<void> applyRemotePayload(Map<String, dynamic> payload) async {
    final String id = payload[SyncMetadataKeys.id] as String;
    final FactoryStatusEntity entity = FactoryStatusEntity(
      id: id,
      createdAt: DateTime.parse(payload[SyncMetadataKeys.createdAt] as String),
      updatedAt: DateTime.parse(payload[SyncMetadataKeys.updatedAt] as String),
      syncStatus: SyncStatus.synced,
      status: FactoryStatusType.values.byName(payload['status'] as String),
      notes: payload['notes'] as String?,
    );
    await _box.put(id, FactoryStatusHiveModel.fromEntity(entity));
  }
}
