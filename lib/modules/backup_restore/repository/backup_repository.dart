import '../domain/models/backup_file_result.dart';
import '../domain/models/google_sheets_backup_result.dart';

/// Contract for backup and restore operations.
abstract class BackupRepository {
  /// Returns record counts per Hive module box.
  Future<Map<String, int>> getRecordCounts();

  /// Creates a JSON backup, saves locally, and shares the file.
  Future<BackupFileResult> createAndShareJsonBackup();

  /// Restores Hive data from a JSON backup file at [filePath].
  Future<int> restoreFromJsonFile(String filePath);

  /// Exports local data to a new Google Spreadsheet.
  Future<GoogleSheetsBackupResult> backupToGoogleSheets();
}
