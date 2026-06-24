import 'package:equatable/equatable.dart';

/// Screen status for backup and restore actions.
enum BackupRestoreStatus {
  /// Initial / idle state.
  idle,

  /// Loading overview metrics.
  loading,

  /// JSON backup in progress.
  exportingJson,

  /// JSON restore in progress.
  restoringJson,

  /// Google Sheets export in progress.
  exportingSheets,

  /// Last action completed successfully.
  success,

  /// Last action failed.
  failure,
}

/// State for backup and restore screen.
class BackupRestoreState extends Equatable {
  /// Creates [BackupRestoreState].
  const BackupRestoreState({
    this.status = BackupRestoreStatus.idle,
    this.recordCounts = const <String, int>{},
    this.totalRecords = 0,
    this.successMessage,
    this.errorMessage,
    this.lastBackupPath,
    this.lastSheetsUrl,
  });

  /// Current action status.
  final BackupRestoreStatus status;

  /// Record counts per module box.
  final Map<String, int> recordCounts;

  /// Sum of all module record counts.
  final int totalRecords;

  /// User-facing success message after an action.
  final String? successMessage;

  /// Error message when [status] is [BackupRestoreStatus.failure].
  final String? errorMessage;

  /// Path to the last saved JSON backup file.
  final String? lastBackupPath;

  /// URL of the last Google Sheets export.
  final String? lastSheetsUrl;

  BackupRestoreState copyWith({
    BackupRestoreStatus? status,
    Map<String, int>? recordCounts,
    int? totalRecords,
    String? successMessage,
    String? errorMessage,
    String? lastBackupPath,
    String? lastSheetsUrl,
    bool clearSuccess = false,
    bool clearError = false,
    bool clearSheetsUrl = false,
  }) {
    return BackupRestoreState(
      status: status ?? this.status,
      recordCounts: recordCounts ?? this.recordCounts,
      totalRecords: totalRecords ?? this.totalRecords,
      successMessage:
          clearSuccess ? null : successMessage ?? this.successMessage,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      lastBackupPath: lastBackupPath ?? this.lastBackupPath,
      lastSheetsUrl:
          clearSheetsUrl ? null : lastSheetsUrl ?? this.lastSheetsUrl,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        recordCounts,
        totalRecords,
        successMessage,
        errorMessage,
        lastBackupPath,
        lastSheetsUrl,
      ];
}
