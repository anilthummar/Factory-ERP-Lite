import 'dart:io';

import 'package:factory_erp_lite/core/domain/entities/attachment_entity.dart';
import 'package:factory_erp_lite/core/domain/enums/attachment_type.dart';
import 'package:factory_erp_lite/core/enums/sync_status.dart';
import 'package:factory_erp_lite/modules/attachments/domain/usecases/pick_and_save_attachment_use_case.dart';
import 'package:factory_erp_lite/modules/attachments/datasource/attachment_local_data_source_impl.dart';
import 'package:factory_erp_lite/modules/attachments/datasource/attachment_local_exception.dart';
import 'package:factory_erp_lite/modules/attachments/repository/attachment_repository_impl.dart';
import 'package:factory_erp_lite/modules/attachments/service/attachment_file_service.dart';
import 'package:factory_erp_lite/service/hive/hive_manager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory hiveDir;
  late Directory tempFilesDir;
  late AttachmentRepositoryImpl repository;
  late AttachmentFileService fileService;
  late PickAndSaveAttachmentUseCase pickAndSaveUseCase;

  setUpAll(() async {
    hiveDir = Directory.systemTemp.createTempSync('attachment_repo_test');
    await HiveManager.instance.initForTests(hiveDir.path);
  });

  tearDownAll(() async {
    if (hiveDir.existsSync()) {
      hiveDir.deleteSync(recursive: true);
    }
  });

  setUp(() async {
    await HiveManager.instance.attachmentsBox.clear();
    tempFilesDir = Directory.systemTemp.createTempSync('attachment_files');
    fileService = AttachmentFileService(documentsDirectory: tempFilesDir);
    repository = AttachmentRepositoryImpl(
      localDataSource: AttachmentLocalDataSourceImpl(),
      fileService: fileService,
    );
    pickAndSaveUseCase = PickAndSaveAttachmentUseCase(repository, fileService);
  });

  tearDown(() {
    if (tempFilesDir.existsSync()) {
      tempFilesDir.deleteSync(recursive: true);
    }
  });

  test('saveFromPlatformFile persists metadata and local file copy', () async {
    final File source = File('${tempFilesDir.path}/receipt.pdf');
    await source.writeAsBytes(<int>[1, 2, 3, 4]);

    final AttachmentEntity saved = await pickAndSaveUseCase.saveFromPlatformFile(
      file: PlatformFile(
        name: 'receipt.pdf',
        path: source.path,
        size: 4,
      ),
      attachmentType: AttachmentType.receipt,
    );

    expect(saved.fileName, 'receipt.pdf');
    expect(saved.mimeType, 'application/pdf');
    expect(saved.syncStatus, SyncStatus.pending);
    expect(File(saved.localPath).existsSync(), isTrue);

    final AttachmentEntity? loaded = await repository.getById(saved.id);
    expect(loaded?.localPath, saved.localPath);
  });

  test('rejects unsupported file types', () async {
    final File source = File('${tempFilesDir.path}/notes.txt');
    await source.writeAsString('hello');

    expect(
      () => pickAndSaveUseCase.saveFromPlatformFile(
        file: PlatformFile(
          name: 'notes.txt',
          path: source.path,
          size: 5,
        ),
      ),
      throwsA(isA<UnsupportedAttachmentTypeException>()),
    );
  });
}
