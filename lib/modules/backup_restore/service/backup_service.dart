import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../datasource/backup_local_data_source.dart';
import '../domain/models/backup_file_result.dart';
import '../domain/models/backup_manifest.dart';
import '../domain/models/backup_progress.dart';

/// Exports all supported Hive modules to a versioned JSON backup file.
class BackupService {
  /// Creates [BackupService].
  BackupService({
    required BackupLocalDataSource localDataSource,
    Directory? backupsDirectory,
  })  : _localDataSource = localDataSource,
        _backupsDirectory = backupsDirectory;

  final BackupLocalDataSource _localDataSource;
  final Directory? _backupsDirectory;

  /// Builds a versioned backup payload from local Hive data.
  Future<Map<String, dynamic>> buildPayload({
    BackupProgressCallback? onProgress,
  }) async {
    onProgress?.call(
      const BackupProgress(
        stage: 'Reading local data',
        completedSteps: 0,
        totalSteps: 2,
      ),
    );

    final Map<String, dynamic> modules = await _localDataSource.exportModules();

    onProgress?.call(
      const BackupProgress(
        stage: 'Preparing backup file',
        completedSteps: 1,
        totalSteps: 2,
      ),
    );

    return <String, dynamic>{
      'formatVersion': BackupManifest.currentVersion,
      'app': BackupManifest.appId,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'modules': modules,
    };
  }

  /// Encodes [payload] as indented JSON.
  String encodePayload(Map<String, dynamic> payload) {
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  /// Counts records in a backup [payload].
  int countRecords(Map<String, dynamic> payload) {
    final Map<String, dynamic> modules =
        Map<String, dynamic>.from(payload['modules'] as Map<dynamic, dynamic>);

    int total = 0;
    for (final String key in BackupManifest.supportedModuleKeys) {
      final dynamic moduleData = modules[key];
      if (moduleData is List<dynamic>) {
        total += moduleData.length;
      }
    }
    return total;
  }

  /// Exports Hive data, saves locally, and shares the JSON backup file.
  Future<BackupFileResult> exportAndShare({
    BackupProgressCallback? onProgress,
  }) async {
    final Map<String, dynamic> payload = await buildPayload(
      onProgress: onProgress,
    );
    final String jsonContent = encodePayload(payload);
    final int recordCount = countRecords(payload);

    onProgress?.call(
      const BackupProgress(
        stage: 'Saving backup file',
        completedSteps: 2,
        totalSteps: 3,
      ),
    );

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

    onProgress?.call(
      const BackupProgress(
        stage: 'Backup complete',
        completedSteps: 3,
        totalSteps: 3,
      ),
    );

    await Share.shareXFiles(
      <XFile>[
        XFile(
          file.path,
          name: fileName,
          mimeType: 'application/json',
        ),
      ],
      subject: fileName,
    );

    return BackupFileResult(
      fileName: fileName,
      filePath: file.path,
      jsonContent: jsonContent,
      recordCount: recordCount,
    );
  }

  Future<Directory> _resolveBackupsDir() async {
    final Directory documentsDir = await getApplicationDocumentsDirectory();
    return Directory('${documentsDir.path}/backups');
  }
}
