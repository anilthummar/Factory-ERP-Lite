import 'package:hive_ce/hive_ce.dart';

import '../../../core/domain/entities/person_entity.dart';
import '../../../core/domain/sync_metadata_keys.dart';
import '../../../core/enums/sync_status.dart';
import '../../../core/sync/sync_module_type.dart';
import '../../hive/hive_manager.dart';
import '../../../modules/person_management/model/local/person_hive_model.dart';
import 'sync_module_handler.dart';

/// Sync handler for person management records.
class PersonSyncModuleHandler implements SyncModuleHandler {
  /// Creates [PersonSyncModuleHandler].
  PersonSyncModuleHandler({HiveManager? hiveManager})
      : _hiveManager = hiveManager ?? HiveManager.instance;

  final HiveManager _hiveManager;

  @override
  SyncModuleType get moduleType => SyncModuleType.personManagement;

  Box<PersonHiveModel> get _box => _hiveManager.personBox;

  @override
  Future<Map<String, dynamic>?> loadPayload(String recordId) async {
    final PersonHiveModel? model = _box.get(recordId);
    if (model == null) {
      return null;
    }

    final PersonEntity person = model.toEntity();
    return <String, dynamic>{
      SyncMetadataKeys.id: person.id,
      SyncMetadataKeys.createdAt: person.createdAt.toIso8601String(),
      SyncMetadataKeys.updatedAt: person.updatedAt.toIso8601String(),
      SyncMetadataKeys.syncStatus: syncStatusToString(person.syncStatus),
      'name': person.name,
      'mobile': person.mobile,
      if (person.address != null) 'address': person.address,
      if (person.notes != null) 'notes': person.notes,
    };
  }

  @override
  Future<void> updateRecordSyncStatus(
    String recordId,
    SyncStatus status,
  ) async {
    final PersonHiveModel? model = _box.get(recordId);
    if (model == null) {
      return;
    }

    final PersonEntity person = model.toEntity();
    await _box.put(
      recordId,
      PersonHiveModel.fromEntity(
        PersonEntity(
          id: person.id,
          createdAt: person.createdAt,
          updatedAt: DateTime.now(),
          syncStatus: status,
          name: person.name,
          mobile: person.mobile,
          address: person.address,
          notes: person.notes,
        ),
      ),
    );
  }

  @override
  Future<void> applyRemotePayload(Map<String, dynamic> payload) async {
    final String id = payload[SyncMetadataKeys.id] as String;
    final PersonEntity person = PersonEntity(
      id: id,
      createdAt: DateTime.parse(payload[SyncMetadataKeys.createdAt] as String),
      updatedAt: DateTime.parse(payload[SyncMetadataKeys.updatedAt] as String),
      syncStatus: SyncStatus.synced,
      name: payload['name'] as String,
      mobile: payload['mobile'] as String,
      address: payload['address'] as String?,
      notes: payload['notes'] as String?,
    );
    await _box.put(id, PersonHiveModel.fromEntity(person));
  }
}
