import 'package:hive_ce/hive_ce.dart';

import '../../../../core/domain/entities/attachment_entity.dart';
import '../../../../core/domain/enums/attachment_type.dart';
import '../../../../core/enums/sync_status.dart';
import '../../../../core/hive/hive_type_ids.dart';
import '../../../../core/sync/sync_module_type.dart';

part 'attachment_hive_model.g.dart';

/// Hive persistence model for [AttachmentEntity].
@HiveType(typeId: HiveTypeIds.attachmentHiveModel)
class AttachmentHiveModel {
  /// Creates [AttachmentHiveModel].
  AttachmentHiveModel({
    required this.id,
    required this.createdAtMs,
    required this.updatedAtMs,
    required this.syncStatusValue,
    required this.fileName,
    required this.localPath,
    required this.mimeType,
    required this.fileSizeBytes,
    required this.attachmentTypeValue,
    this.parentModuleValue,
    this.parentRecordId,
    this.downloadUrl,
    this.storagePath,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final int createdAtMs;

  @HiveField(2)
  final int updatedAtMs;

  @HiveField(3)
  final String syncStatusValue;

  @HiveField(4)
  final String fileName;

  @HiveField(5)
  final String localPath;

  @HiveField(6)
  final String mimeType;

  @HiveField(7)
  final int fileSizeBytes;

  @HiveField(8)
  final String attachmentTypeValue;

  @HiveField(9)
  final String? parentModuleValue;

  @HiveField(10)
  final String? parentRecordId;

  @HiveField(11)
  final String? downloadUrl;

  @HiveField(12)
  final String? storagePath;

  /// Converts this model to a domain entity.
  AttachmentEntity toEntity() {
    return AttachmentEntity(
      id: id,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAtMs),
      syncStatus: syncStatusFromString(syncStatusValue),
      fileName: fileName,
      localPath: localPath,
      mimeType: mimeType,
      fileSizeBytes: fileSizeBytes,
      attachmentType: attachmentTypeFromString(attachmentTypeValue),
      parentModule: parentModuleValue == null
          ? null
          : syncModuleTypeFromString(parentModuleValue),
      parentRecordId: parentRecordId,
      downloadUrl: downloadUrl,
      storagePath: storagePath,
    );
  }

  /// Creates a Hive model from [entity].
  factory AttachmentHiveModel.fromEntity(AttachmentEntity entity) {
    return AttachmentHiveModel(
      id: entity.id,
      createdAtMs: entity.createdAt.millisecondsSinceEpoch,
      updatedAtMs: entity.updatedAt.millisecondsSinceEpoch,
      syncStatusValue: syncStatusToString(entity.syncStatus),
      fileName: entity.fileName,
      localPath: entity.localPath,
      mimeType: entity.mimeType,
      fileSizeBytes: entity.fileSizeBytes,
      attachmentTypeValue: attachmentTypeToString(entity.attachmentType),
      parentModuleValue: entity.parentModule == null
          ? null
          : syncModuleTypeToString(entity.parentModule!),
      parentRecordId: entity.parentRecordId,
      downloadUrl: entity.downloadUrl,
      storagePath: entity.storagePath,
    );
  }
}
