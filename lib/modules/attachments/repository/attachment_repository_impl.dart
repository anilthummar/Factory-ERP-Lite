import '../../../core/domain/entities/attachment_entity.dart';
import '../../../core/domain/repositories/attachment_repository.dart';
import '../../../core/sync/sync_module_type.dart';
import '../../../service/sync/offline_first_sync_support.dart';
import '../datasource/attachment_local_data_source.dart';
import '../datasource/attachment_local_exception.dart';
import '../service/attachment_file_service.dart';

/// Hive-backed [AttachmentRepository] implementation.
class AttachmentRepositoryImpl implements AttachmentRepository {
  /// Creates [AttachmentRepositoryImpl].
  AttachmentRepositoryImpl({
    required AttachmentLocalDataSource localDataSource,
    required AttachmentFileService fileService,
    OfflineFirstSyncSupport? syncSupport,
  })  : _localDataSource = localDataSource,
        _fileService = fileService,
        _syncSupport = syncSupport ?? const OfflineFirstSyncSupport(null);

  final AttachmentLocalDataSource _localDataSource;
  final AttachmentFileService _fileService;
  final OfflineFirstSyncSupport _syncSupport;

  @override
  Future<AttachmentEntity> create(AttachmentEntity attachment) async {
    try {
      final AttachmentEntity saved =
          await _localDataSource.add(attachment);
      await _syncSupport.afterCreate(
        module: SyncModuleType.attachments,
        recordId: saved.id,
      );
      return saved;
    } on AttachmentLocalException {
      rethrow;
    }
  }

  @override
  Future<AttachmentEntity?> getById(String id) {
    return _localDataSource.getById(id);
  }

  @override
  Future<List<AttachmentEntity>> getAll() {
    return _localDataSource.getAll();
  }

  @override
  Future<List<AttachmentEntity>> getByParent({
    required SyncModuleType parentModule,
    required String parentRecordId,
  }) {
    return _localDataSource.getByParent(
      parentModule: parentModule,
      parentRecordId: parentRecordId,
    );
  }

  @override
  Future<List<AttachmentEntity>> getFailed() {
    return _localDataSource.getFailed();
  }

  @override
  Future<AttachmentEntity> update(AttachmentEntity attachment) async {
    try {
      final AttachmentEntity saved =
          await _localDataSource.update(attachment);
      await _syncSupport.afterUpdate(
        module: SyncModuleType.attachments,
        recordId: saved.id,
      );
      return saved;
    } on AttachmentLocalException {
      rethrow;
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      final AttachmentEntity? existing = await _localDataSource.getById(id);
      await _localDataSource.delete(id);
      if (existing != null) {
        await _fileService.deleteLocalFile(existing.localPath);
      }
      await _syncSupport.afterDelete(
        module: SyncModuleType.attachments,
        recordId: id,
      );
    } on AttachmentLocalException {
      rethrow;
    }
  }

  /// Deletes only the on-disk file copy without removing metadata.
  Future<void> deleteLocalFileCopy(String localPath) {
    return _fileService.deleteLocalFile(localPath);
  }
}
