import '../../../../core/domain/entities/attachment_entity.dart';
import '../../../../core/domain/enums/attachment_type.dart';
import '../../../../core/domain/sync_metadata_keys.dart';
import '../../../../core/enums/sync_status.dart';
import '../../../../core/sync/sync_module_type.dart';

/// Firestore document shape for attachment metadata.
class AttachmentRemoteModel {
  /// Creates [AttachmentRemoteModel].
  const AttachmentRemoteModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    required this.fileName,
    required this.mimeType,
    required this.fileSizeBytes,
    required this.attachmentType,
    required this.downloadUrl,
    required this.storagePath,
    this.parentModule,
    this.parentRecordId,
  });

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final String fileName;
  final String mimeType;
  final int fileSizeBytes;
  final AttachmentType attachmentType;
  final String downloadUrl;
  final String storagePath;
  final SyncModuleType? parentModule;
  final String? parentRecordId;

  /// Converts a domain entity to a remote model.
  factory AttachmentRemoteModel.fromEntity(AttachmentEntity entity) {
    return AttachmentRemoteModel(
      id: entity.id,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      syncStatus: entity.syncStatus,
      fileName: entity.fileName,
      mimeType: entity.mimeType,
      fileSizeBytes: entity.fileSizeBytes,
      attachmentType: entity.attachmentType,
      downloadUrl: entity.downloadUrl ?? '',
      storagePath: entity.storagePath ?? '',
      parentModule: entity.parentModule,
      parentRecordId: entity.parentRecordId,
    );
  }

  /// Parses a Firestore document map.
  factory AttachmentRemoteModel.fromMap(Map<String, dynamic> map) {
    return AttachmentRemoteModel(
      id: map[SyncMetadataKeys.id] as String,
      createdAt: DateTime.parse(map[SyncMetadataKeys.createdAt] as String),
      updatedAt: DateTime.parse(map[SyncMetadataKeys.updatedAt] as String),
      syncStatus: syncStatusFromString(
        map[SyncMetadataKeys.syncStatus] as String? ?? 'synced',
      ),
      fileName: map['fileName'] as String,
      mimeType: map['mimeType'] as String,
      fileSizeBytes: map['fileSizeBytes'] as int,
      attachmentType: attachmentTypeFromString(map['attachmentType'] as String?),
      downloadUrl: map['downloadUrl'] as String,
      storagePath: map['storagePath'] as String,
      parentModule: map['parentModule'] == null
          ? null
          : syncModuleTypeFromString(map['parentModule'] as String?),
      parentRecordId: map['parentRecordId'] as String?,
    );
  }

  /// Converts to a domain entity.
  AttachmentEntity toEntity() {
    return AttachmentEntity(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
      fileName: fileName,
      localPath: '',
      mimeType: mimeType,
      fileSizeBytes: fileSizeBytes,
      attachmentType: attachmentType,
      parentModule: parentModule,
      parentRecordId: parentRecordId,
      downloadUrl: downloadUrl,
      storagePath: storagePath,
    );
  }

  /// Serializes to a Firestore document map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      SyncMetadataKeys.id: id,
      SyncMetadataKeys.createdAt: createdAt.toIso8601String(),
      SyncMetadataKeys.updatedAt: updatedAt.toIso8601String(),
      SyncMetadataKeys.syncStatus: syncStatusToString(syncStatus),
      'fileName': fileName,
      'mimeType': mimeType,
      'fileSizeBytes': fileSizeBytes,
      'attachmentType': attachmentTypeToString(attachmentType),
      'downloadUrl': downloadUrl,
      'storagePath': storagePath,
      if (parentModule != null)
        'parentModule': syncModuleTypeToString(parentModule!),
      if (parentRecordId != null) 'parentRecordId': parentRecordId,
    };
  }
}
