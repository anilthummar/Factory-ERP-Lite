import '../../repository/backup_repository.dart';

/// Loads record counts for backup overview.
class GetBackupOverviewUseCase {
  /// Creates [GetBackupOverviewUseCase].
  const GetBackupOverviewUseCase(this._repository);

  final BackupRepository _repository;

  /// Returns record counts per module.
  Future<Map<String, int>> call() => _repository.getRecordCounts();
}
