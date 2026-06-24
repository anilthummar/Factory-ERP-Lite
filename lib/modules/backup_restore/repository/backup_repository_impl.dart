import 'dart:io';

import '../datasource/backup_local_data_source.dart';
import '../domain/models/backup_file_result.dart';
import '../domain/models/google_sheets_backup_result.dart';
import '../service/backup_file_service.dart';
import '../service/google_sheets_backup_service.dart';
import '../service/json_backup_service.dart';
import 'backup_repository.dart';

/// Implements [BackupRepository] using Hive and export services.
class BackupRepositoryImpl implements BackupRepository {
  /// Creates [BackupRepositoryImpl].
  BackupRepositoryImpl({
    required BackupLocalDataSource localDataSource,
    required JsonBackupService jsonBackupService,
    required BackupFileService backupFileService,
    required GoogleSheetsBackupService googleSheetsBackupService,
  })  : _localDataSource = localDataSource,
        _jsonBackupService = jsonBackupService,
        _backupFileService = backupFileService,
        _googleSheetsBackupService = googleSheetsBackupService;

  final BackupLocalDataSource _localDataSource;
  final JsonBackupService _jsonBackupService;
  final BackupFileService _backupFileService;
  final GoogleSheetsBackupService _googleSheetsBackupService;

  @override
  Future<Map<String, int>> getRecordCounts() {
    return _localDataSource.recordCounts();
  }

  @override
  Future<BackupFileResult> createAndShareJsonBackup() async {
    final Map<String, dynamic> payload =
        await _jsonBackupService.buildBackupPayload();
    final String jsonContent = _jsonBackupService.encode(payload);
    final int recordCount = _jsonBackupService.countRecords(payload);

    return _backupFileService.saveAndShare(
      jsonContent: jsonContent,
      recordCount: recordCount,
    );
  }

  @override
  Future<int> restoreFromJsonFile(String filePath) async {
    final String jsonContent = await File(filePath).readAsString();
    final Map<String, dynamic> payload = _jsonBackupService.decode(jsonContent);
    final Map<String, dynamic> modules = Map<String, dynamic>.from(
      payload['modules'] as Map<dynamic, dynamic>,
    );

    await _localDataSource.restoreAllModules(modules);
    return _jsonBackupService.countRecords(payload);
  }

  @override
  Future<GoogleSheetsBackupResult> backupToGoogleSheets() {
    return _googleSheetsBackupService.exportToNewSpreadsheet();
  }
}
