import '../../datasource/backup_local_data_source.dart';
import '../models/backup_progress.dart';
import '../models/backup_validation_result.dart';
import '../../service/restore_service.dart';

/// Validates a JSON backup file before restore.
class ValidateBackupFileUseCase {
  /// Creates [ValidateBackupFileUseCase].
  const ValidateBackupFileUseCase(this._restoreService);

  final RestoreService _restoreService;

  /// Returns validation outcome for [filePath].
  Future<BackupValidationResult> call(String filePath) {
    return _restoreService.validateFile(filePath);
  }
}

/// Restores Hive data from a validated JSON backup file.
class RestoreLocalJsonBackupUseCase {
  /// Creates [RestoreLocalJsonBackupUseCase].
  const RestoreLocalJsonBackupUseCase(this._restoreService);

  final RestoreService _restoreService;

  /// Imports all supported modules from [filePath].
  Future<int> call(
    String filePath, {
    BackupProgressCallback? onProgress,
  }) {
    return _restoreService.restoreFromFile(
      filePath,
      onProgress: onProgress,
    );
  }
}
