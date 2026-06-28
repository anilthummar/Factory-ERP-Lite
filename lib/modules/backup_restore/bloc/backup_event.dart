import 'package:equatable/equatable.dart';

/// Events for the backup screen.
sealed class BackupEvent extends Equatable {
  const BackupEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Loads module record counts.
final class BackupLoadRequested extends BackupEvent {
  /// Creates [BackupLoadRequested].
  const BackupLoadRequested();
}

/// Exports a local JSON backup.
final class BackupExportRequested extends BackupEvent {
  /// Creates [BackupExportRequested].
  const BackupExportRequested();
}

/// Validates a selected backup file before restore.
final class BackupValidateRequested extends BackupEvent {
  /// Creates [BackupValidateRequested].
  const BackupValidateRequested(this.filePath);

  /// Absolute path to the selected backup file.
  final String filePath;

  @override
  List<Object?> get props => <Object?>[filePath];
}

/// Restores from a previously validated backup file.
final class BackupRestoreRequested extends BackupEvent {
  /// Creates [BackupRestoreRequested].
  const BackupRestoreRequested(this.filePath);

  /// Absolute path to the validated backup file.
  final String filePath;

  @override
  List<Object?> get props => <Object?>[filePath];
}
