import 'package:file_picker/file_picker.dart';

import '../../../../core/domain/entities/attachment_entity.dart';
import '../../../../core/domain/enums/attachment_type.dart';
import '../../../../core/domain/repositories/attachment_repository.dart';
import '../../../../core/enums/sync_status.dart';
import '../../../../core/sync/sync_module_type.dart';
import '../../datasource/attachment_local_exception.dart';
import '../../service/attachment_file_service.dart';

/// Picks a file and saves attachment metadata locally (offline-first).
class PickAndSaveAttachmentUseCase {
  /// Creates [PickAndSaveAttachmentUseCase].
  const PickAndSaveAttachmentUseCase(
    this._repository,
    this._fileService,
  );

  final AttachmentRepository _repository;
  final AttachmentFileService _fileService;

  /// Opens the system picker and persists the selected file.
  Future<AttachmentEntity?> pickAndSave({
    AttachmentType attachmentType = AttachmentType.document,
    SyncModuleType? parentModule,
    String? parentRecordId,
  }) async {
    final FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final PlatformFile file = result.files.first;
    if (file.path == null) {
      return null;
    }

    return saveFromPlatformFile(
      file: file,
      attachmentType: attachmentType,
      parentModule: parentModule,
      parentRecordId: parentRecordId,
    );
  }

  /// Persists an already picked [file] without opening the picker again.
  Future<AttachmentEntity> saveFromPlatformFile({
    required PlatformFile file,
    AttachmentType attachmentType = AttachmentType.document,
    SyncModuleType? parentModule,
    String? parentRecordId,
  }) async {
    final String? path = file.path;
    if (path == null) {
      throw const AttachmentLocalException('Picked file has no local path.');
    }

    final String fileName = file.name;
    if (!AttachmentFileTypes.isSupported(fileName)) {
      throw UnsupportedAttachmentTypeException(fileName);
    }

    final String? mimeType = AttachmentFileTypes.mimeTypeForFileName(fileName);
    if (mimeType == null) {
      throw UnsupportedAttachmentTypeException(fileName);
    }

    final DateTime now = DateTime.now();
    final String id = 'attachment_${now.microsecondsSinceEpoch}';
    final String localPath = await _fileService.persistPickedFile(
      sourcePath: path,
      attachmentId: id,
      fileName: fileName,
    );
    final int fileSizeBytes = await _fileService.fileSizeBytes(localPath);

    final AttachmentEntity entity = AttachmentEntity(
      id: id,
      createdAt: now,
      updatedAt: now,
      syncStatus: SyncStatus.pending,
      fileName: fileName,
      localPath: localPath,
      mimeType: mimeType,
      fileSizeBytes: fileSizeBytes,
      attachmentType: attachmentType,
      parentModule: parentModule,
      parentRecordId: parentRecordId,
    );

    return _repository.create(entity);
  }
}
