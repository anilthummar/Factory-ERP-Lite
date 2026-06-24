import 'package:hive_ce/hive_ce.dart';

import '../../../core/domain/entities/attachment_entity.dart';
import '../../../core/enums/sync_status.dart';
import '../../../core/sync/sync_module_type.dart';
import '../../../service/hive/hive_manager.dart';
import '../model/local/attachment_hive_model.dart';
import 'attachment_local_data_source.dart';
import 'attachment_local_exception.dart';

/// Hive implementation of [AttachmentLocalDataSource].
class AttachmentLocalDataSourceImpl implements AttachmentLocalDataSource {
  /// Creates [AttachmentLocalDataSourceImpl].
  AttachmentLocalDataSourceImpl({HiveManager? hiveManager})
      : _hiveManager = hiveManager ?? HiveManager.instance;

  final HiveManager _hiveManager;

  Box<AttachmentHiveModel> get _box => _hiveManager.attachmentsBox;

  @override
  Future<List<AttachmentEntity>> getAll() async {
    return _runStorage('load attachments', () async {
      final List<AttachmentEntity> attachments = _box.values
          .map((AttachmentHiveModel model) => model.toEntity())
          .toList(growable: false);
      return _sortNewestFirst(attachments);
    });
  }

  @override
  Future<List<AttachmentEntity>> getByParent({
    required SyncModuleType parentModule,
    required String parentRecordId,
  }) async {
    return _runStorage('load parent attachments', () async {
      final List<AttachmentEntity> attachments = _box.values
          .map((AttachmentHiveModel model) => model.toEntity())
          .where(
            (AttachmentEntity attachment) =>
                attachment.parentModule == parentModule &&
                attachment.parentRecordId == parentRecordId,
          )
          .toList(growable: false);
      return _sortNewestFirst(attachments);
    });
  }

  @override
  Future<List<AttachmentEntity>> getFailed() async {
    return _runStorage('load failed attachments', () async {
      final List<AttachmentEntity> attachments = _box.values
          .map((AttachmentHiveModel model) => model.toEntity())
          .where(
            (AttachmentEntity attachment) =>
                attachment.syncStatus == SyncStatus.failed,
          )
          .toList(growable: false);
      return _sortNewestFirst(attachments);
    });
  }

  @override
  Future<AttachmentEntity?> getById(String id) async {
    return _runStorage('load attachment', () async {
      final AttachmentHiveModel? model = _box.get(id);
      return model?.toEntity();
    });
  }

  @override
  Future<AttachmentEntity> add(AttachmentEntity attachment) async {
    return _runStorage('add attachment', () async {
      final AttachmentHiveModel model =
          AttachmentHiveModel.fromEntity(attachment);
      await _box.put(attachment.id, model);
      return model.toEntity();
    });
  }

  @override
  Future<AttachmentEntity> update(AttachmentEntity attachment) async {
    return _runStorage('update attachment', () async {
      if (!_box.containsKey(attachment.id)) {
        throw AttachmentNotFoundException(attachment.id);
      }

      final AttachmentHiveModel model =
          AttachmentHiveModel.fromEntity(attachment);
      await _box.put(attachment.id, model);
      return model.toEntity();
    });
  }

  @override
  Future<void> delete(String id) async {
    await _runStorage('delete attachment', () async {
      if (!_box.containsKey(id)) {
        throw AttachmentNotFoundException(id);
      }
      await _box.delete(id);
    });
  }

  Future<T> _runStorage<T>(
    String operation,
    Future<T> Function() action,
  ) async {
    if (!_hiveManager.isInitialized) {
      throw AttachmentLocalStorageException(
        'Hive is not initialized. Cannot $operation.',
      );
    }

    if (!_hiveManager.isAttachmentsBoxOpen) {
      throw AttachmentLocalStorageException(
        'Attachments Hive box is not open. Cannot $operation.',
      );
    }

    try {
      return await action();
    } on AttachmentLocalException {
      rethrow;
    } on HiveError catch (error) {
      throw AttachmentLocalStorageException(
        'Hive error while trying to $operation: ${error.message}',
      );
    } on Object catch (error) {
      throw AttachmentLocalStorageException(
        'Unexpected error while trying to $operation: $error',
      );
    }
  }

  List<AttachmentEntity> _sortNewestFirst(
    List<AttachmentEntity> attachments,
  ) {
    final List<AttachmentEntity> sorted =
        List<AttachmentEntity>.from(attachments)
          ..sort(
            (AttachmentEntity a, AttachmentEntity b) =>
                b.updatedAt.compareTo(a.updatedAt),
          );
    return sorted;
  }
}
