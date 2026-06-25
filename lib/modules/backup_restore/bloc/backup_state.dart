import 'package:equatable/equatable.dart';

import '../domain/models/backup_progress.dart';
import '../domain/models/backup_validation_result.dart';

/// Screen status for backup operations.
enum BackupStatus {
  /// Idle / ready.
  idle,

  /// Loading overview.
  loading,

  /// Exporting JSON backup.
  exporting,

  /// Validating selected backup file.
  validating,

  /// Restoring from backup.
  restoring,

  /// Awaiting user confirmation after validation.
  awaitingConfirmation,

  /// Last action succeeded.
  success,

  /// Last action failed.
  failure,
}

/// State for [BackupBloc].
class BackupState extends Equatable {
  /// Creates [BackupState].
  const BackupState({
    this.status = BackupStatus.idle,
    this.recordCounts = const <String, int>{},
    this.totalRecords = 0,
    this.progress,
    this.validation,
    this.pendingRestorePath,
    this.successMessage,
    this.errorMessage,
    this.lastBackupPath,
  });

  /// Current operation status.
  final BackupStatus status;

  /// Local record counts per module.
  final Map<String, int> recordCounts;

  /// Sum of local record counts.
  final int totalRecords;

  /// Latest progress update for export/restore.
  final BackupProgress? progress;

  /// Validation result for a selected backup file.
  final BackupValidationResult? validation;

  /// File path waiting for user restore confirmation.
  final String? pendingRestorePath;

  /// Success message after an operation.
  final String? successMessage;

  /// Error message when [status] is [BackupStatus.failure].
  final String? errorMessage;

  /// Path to the last exported backup file.
  final String? lastBackupPath;

  BackupState copyWith({
    BackupStatus? status,
    Map<String, int>? recordCounts,
    int? totalRecords,
    BackupProgress? progress,
    BackupValidationResult? validation,
    String? pendingRestorePath,
    String? successMessage,
    String? errorMessage,
    String? lastBackupPath,
    bool clearProgress = false,
    bool clearValidation = false,
    bool clearPendingPath = false,
    bool clearSuccess = false,
    bool clearError = false,
  }) {
    return BackupState(
      status: status ?? this.status,
      recordCounts: recordCounts ?? this.recordCounts,
      totalRecords: totalRecords ?? this.totalRecords,
      progress: clearProgress ? null : progress ?? this.progress,
      validation: clearValidation ? null : validation ?? this.validation,
      pendingRestorePath: clearPendingPath
          ? null
          : pendingRestorePath ?? this.pendingRestorePath,
      successMessage:
          clearSuccess ? null : successMessage ?? this.successMessage,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      lastBackupPath: lastBackupPath ?? this.lastBackupPath,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        recordCounts,
        totalRecords,
        progress,
        validation,
        pendingRestorePath,
        successMessage,
        errorMessage,
        lastBackupPath,
      ];
}
