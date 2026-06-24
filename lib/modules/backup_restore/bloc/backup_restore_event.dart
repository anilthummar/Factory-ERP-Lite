import 'package:equatable/equatable.dart';

/// Events for backup and restore screen.
sealed class BackupRestoreEvent extends Equatable {
  const BackupRestoreEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Loads module record counts.
final class BackupRestoreLoadRequested extends BackupRestoreEvent {
  /// Creates [BackupRestoreLoadRequested].
  const BackupRestoreLoadRequested();
}

/// Creates and shares a JSON backup.
final class BackupRestoreJsonExportRequested extends BackupRestoreEvent {
  /// Creates [BackupRestoreJsonExportRequested].
  const BackupRestoreJsonExportRequested();
}

/// Restores from a picked JSON backup file.
final class BackupRestoreJsonImportRequested extends BackupRestoreEvent {
  /// Creates [BackupRestoreJsonImportRequested].
  const BackupRestoreJsonImportRequested(this.filePath);

  /// Absolute path to the selected backup file.
  final String filePath;

  @override
  List<Object?> get props => <Object?>[filePath];
}

/// Exports data to Google Sheets.
final class BackupRestoreGoogleSheetsRequested extends BackupRestoreEvent {
  /// Creates [BackupRestoreGoogleSheetsRequested].
  const BackupRestoreGoogleSheetsRequested();
}
