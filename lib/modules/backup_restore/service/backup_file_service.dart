import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../domain/models/backup_file_result.dart';

/// Saves JSON backup files locally and shares them.
class BackupFileService {
  /// Creates [BackupFileService].
  BackupFileService({Directory? backupsDirectory})
      : _backupsDirectory = backupsDirectory;

  final Directory? _backupsDirectory;

  /// Writes [jsonContent] to app documents and returns file metadata.
  Future<BackupFileResult> saveBackup({
    required String jsonContent,
    required int recordCount,
  }) async {
    final Directory backupsDir =
        _backupsDirectory ?? await _resolveBackupsDir();
    if (!await backupsDir.exists()) {
      await backupsDir.create(recursive: true);
    }

    final String timestamp =
        DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final String fileName = 'factory_erp_backup_$timestamp.json';
    final File file = File('${backupsDir.path}/$fileName');
    await file.writeAsString(jsonContent, flush: true);

    return BackupFileResult(
      fileName: fileName,
      filePath: file.path,
      jsonContent: jsonContent,
      recordCount: recordCount,
    );
  }

  /// Opens the platform share sheet for a saved backup file.
  Future<void> shareBackup({
    required String filePath,
    required String fileName,
  }) {
    return Share.shareXFiles(
      <XFile>[XFile(filePath, name: fileName, mimeType: 'application/json')],
      subject: fileName,
    );
  }

  /// Saves locally and shares a JSON backup in one call.
  Future<BackupFileResult> saveAndShare({
    required String jsonContent,
    required int recordCount,
  }) async {
    final BackupFileResult result = await saveBackup(
      jsonContent: jsonContent,
      recordCount: recordCount,
    );
    await shareBackup(filePath: result.filePath, fileName: result.fileName);
    return result;
  }

  Future<Directory> _resolveBackupsDir() async {
    final Directory documentsDir = await getApplicationDocumentsDirectory();
    return Directory('${documentsDir.path}/backups');
  }
}
