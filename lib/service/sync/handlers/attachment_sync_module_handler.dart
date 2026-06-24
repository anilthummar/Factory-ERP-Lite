import 'package:hive_ce/hive_ce.dart';

import '../../../core/domain/entities/attachment_entity.dart';
import '../../../core/enums/sync_status.dart';
import '../../../core/sync/sync_module_type.dart';
import '../../../modules/attachments/datasource/attachment_storage_remote_data_source.dart';
import '../../../modules/attachments/model/local/attachment_hive_model.dart';
import '../../../modules/attachments/model/remote/attachment_remote_model.dart';
import '../../hive/hive_manager.dart';
import 'sync_module_handler.dart';

/// Sync handler for attachment metadata and Firebase Storage uploads.
class AttachmentSyncModuleHandler implements SyncModuleHandler {
  /// Creates [AttachmentSyncModuleHandler].
  AttachmentSyncModuleHandler({
    required AttachmentStorageRemoteDataSource storageDataSource,
    HiveManager? hiveManager,
  })  : _storageDataSource = storageDataSource,
        _hiveManager = hiveManager ?? HiveManager.instance;

  final AttachmentStorageRemoteDataSource _storageDataSource;
  final HiveManager _hiveManager;

  @override
  SyncModuleType get moduleType => SyncModuleType.attachments;

  Box<AttachmentHiveModel> get _box => _hiveManager.attachmentsBox;

  @override
  Future<Map<String, dynamic>?> loadPayload(String recordId) async {
    final AttachmentHiveModel? model = _box.get(recordId);
    if (model == null) {
      return null;
    }

    AttachmentEntity entity = model.toEntity();
    entity = await _ensureUploaded(entity);
    if (entity.downloadUrl == null || entity.storagePath == null) {
      throw StateError(
        'Attachment $recordId is missing upload URL after storage sync.',
      );
    }

    return AttachmentRemoteModel.fromEntity(entity).toMap();
  }

  @override
  Future<void> updateRecordSyncStatus(
    String recordId,
    SyncStatus status,
  ) async {
    final AttachmentHiveModel? model = _box.get(recordId);
    if (model == null) {
      return;
    }

    final AttachmentEntity entity = model.toEntity();
    await _box.put(
      recordId,
      AttachmentHiveModel.fromEntity(
        entity.copyWith(
          syncStatus: status,
          updatedAt: DateTime.now(),
        ),
      ),
    );
  }

  @override
  Future<void> applyRemotePayload(Map<String, dynamic> payload) async {
    final AttachmentEntity remote =
        AttachmentRemoteModel.fromMap(payload).toEntity();
    final AttachmentHiveModel? existing = _box.get(remote.id);
    final AttachmentEntity merged = AttachmentEntity(
      id: remote.id,
      createdAt: remote.createdAt,
      updatedAt: remote.updatedAt,
      syncStatus: SyncStatus.synced,
      fileName: remote.fileName,
      localPath: existing?.toEntity().localPath ?? '',
      mimeType: remote.mimeType,
      fileSizeBytes: remote.fileSizeBytes,
      attachmentType: remote.attachmentType,
      parentModule: remote.parentModule,
      parentRecordId: remote.parentRecordId,
      downloadUrl: remote.downloadUrl,
      storagePath: remote.storagePath,
    );
    await _box.put(remote.id, AttachmentHiveModel.fromEntity(merged));
  }

  Future<AttachmentEntity> _ensureUploaded(AttachmentEntity entity) async {
    if (entity.downloadUrl != null &&
        entity.downloadUrl!.isNotEmpty &&
        entity.storagePath != null &&
        entity.storagePath!.isNotEmpty) {
      return entity;
    }

    final String storagePath =
        entity.storagePath ?? 'attachments/${entity.id}/${entity.fileName}';
    final AttachmentUploadResult uploadResult =
        await _storageDataSource.uploadFile(
      localPath: entity.localPath,
      storagePath: storagePath,
      contentType: entity.mimeType,
    );

    final AttachmentEntity uploaded = entity.copyWith(
      downloadUrl: uploadResult.downloadUrl,
      storagePath: uploadResult.storagePath,
      updatedAt: DateTime.now(),
    );
    await _box.put(
      entity.id,
      AttachmentHiveModel.fromEntity(uploaded),
    );
    return uploaded;
  }
}
