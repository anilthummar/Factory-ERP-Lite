import '../../domain/models/google_sheets_backup_result.dart';
import '../../repository/backup_repository.dart';

/// Exports factory data to Google Sheets.
class BackupToGoogleSheetsUseCase {
  /// Creates [BackupToGoogleSheetsUseCase].
  const BackupToGoogleSheetsUseCase(this._repository);

  final BackupRepository _repository;

  /// Creates a spreadsheet and writes module tabs.
  Future<GoogleSheetsBackupResult> call() => _repository.backupToGoogleSheets();
}
