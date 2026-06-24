import '../../enums/sync_status.dart';
import '../../sync/sync_module_type.dart';
import '../enums/attachment_type.dart';
import 'syncable_entity.dart';

/// Domain entity for a file attachment linked to ERP records.
class AttachmentEntity extends SyncableEntity {
  /// Creates [AttachmentEntity].
  const AttachmentEntity({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.syncStatus,
    required this.fileName,
    required this.localPath,
    required this.mimeType,
    required this.fileSizeBytes,
    required this.attachmentType,
    this.parentModule,
    this.parentRecordId,
    this.downloadUrl,
    this.storagePath,
  });

  /// Original file name shown in the UI.
  final String fileName;

  /// Absolute path to the locally persisted file copy.
  final String localPath;

  /// MIME type (jpg/png/pdf).
  final String mimeType;

  /// File size in bytes.
  final int fileSizeBytes;

  /// Attachment business category.
  final AttachmentType attachmentType;

  /// Optional parent ERP module.
  final SyncModuleType? parentModule;

  /// Optional parent record identifier.
  final String? parentRecordId;

  /// Firebase Storage download URL after upload.
  final String? downloadUrl;

  /// Firebase Storage object path.
  final String? storagePath;

  /// Returns a copy with selective overrides.
  AttachmentEntity copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    String? fileName,
    String? localPath,
    String? mimeType,
    int? fileSizeBytes,
    AttachmentType? attachmentType,
    SyncModuleType? parentModule,
    String? parentRecordId,
    String? downloadUrl,
    String? storagePath,
    bool clearParentModule = false,
    bool clearParentRecordId = false,
    bool clearDownloadUrl = false,
    bool clearStoragePath = false,
  }) {
    return AttachmentEntity(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      fileName: fileName ?? this.fileName,
      localPath: localPath ?? this.localPath,
      mimeType: mimeType ?? this.mimeType,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      attachmentType: attachmentType ?? this.attachmentType,
      parentModule: clearParentModule ? null : parentModule ?? this.parentModule,
      parentRecordId:
          clearParentRecordId ? null : parentRecordId ?? this.parentRecordId,
      downloadUrl: clearDownloadUrl ? null : downloadUrl ?? this.downloadUrl,
      storagePath: clearStoragePath ? null : storagePath ?? this.storagePath,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        ...super.props,
        fileName,
        localPath,
        mimeType,
        fileSizeBytes,
        attachmentType,
        parentModule,
        parentRecordId,
        downloadUrl,
        storagePath,
      ];
}
