import '../../datasource/backup_local_data_source.dart';
import '../models/backup_file_result.dart';
import '../models/backup_progress.dart';
import '../../service/backup_service.dart';

/// Loads record counts for the backup overview screen.
class GetBackupOverviewUseCase {
  /// Creates [GetBackupOverviewUseCase].
  const GetBackupOverviewUseCase(this._localDataSource);

  final BackupLocalDataSource _localDataSource;

  /// Returns record counts per supported module.
  Future<Map<String, int>> call() => _localDataSource.recordCounts();
}

/// Exports all Hive data to a local JSON backup and shares it.
class ExportLocalJsonBackupUseCase {
  /// Creates [ExportLocalJsonBackupUseCase].
  const ExportLocalJsonBackupUseCase(this._backupService);

  final BackupService _backupService;

  /// Creates, saves, and shares a JSON backup file.
  Future<BackupFileResult> call({
    BackupProgressCallback? onProgress,
  }) {
    return _backupService.exportAndShare(onProgress: onProgress);
  }
}
