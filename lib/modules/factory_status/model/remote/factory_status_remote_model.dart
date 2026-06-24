import '../../../../core/domain/entities/factory_status_entity.dart';
import '../../../../core/domain/enums/factory_status_type.dart';
import '../../../../core/domain/sync_metadata_keys.dart';
import '../../../../core/enums/sync_status.dart';

/// Firestore document shape for factory status history records.
class FactoryStatusRemoteModel {
  /// Creates [FactoryStatusRemoteModel].
  const FactoryStatusRemoteModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.status,
    this.notes,
  });

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final FactoryStatusType status;
  final String? notes;

  /// Converts a domain entity to a remote model.
  factory FactoryStatusRemoteModel.fromEntity(FactoryStatusEntity entity) {
    return FactoryStatusRemoteModel(
      id: entity.id,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      syncStatus: entity.syncStatus,
      status: entity.status,
      notes: entity.notes,
    );
  }

  /// Parses a Firestore document map.
  factory FactoryStatusRemoteModel.fromMap(Map<String, dynamic> map) {
    return FactoryStatusRemoteModel(
      id: map[SyncMetadataKeys.id] as String,
      createdAt: DateTime.parse(map[SyncMetadataKeys.createdAt] as String),
      updatedAt: DateTime.parse(map[SyncMetadataKeys.updatedAt] as String),
      syncStatus: syncStatusFromString(
        map[SyncMetadataKeys.syncStatus] as String? ?? 'synced',
      ),
      status: FactoryStatusType.values.byName(map['status'] as String),
      notes: map['notes'] as String?,
    );
  }

  /// Converts to a domain entity.
  FactoryStatusEntity toEntity() {
    return FactoryStatusEntity(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
      status: status,
      notes: notes,
    );
  }

  /// Serializes to a Firestore document map for sync push.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      SyncMetadataKeys.id: id,
      SyncMetadataKeys.createdAt: createdAt.toIso8601String(),
      SyncMetadataKeys.updatedAt: updatedAt.toIso8601String(),
      SyncMetadataKeys.syncStatus: syncStatusToString(syncStatus),
      'status': status.name,
      if (notes != null) 'notes': notes,
    };
  }
}
