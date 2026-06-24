import '../../repository/backup_repository.dart';

/// Restores factory data from a JSON backup file.
class RestoreJsonBackupUseCase {
  /// Creates [RestoreJsonBackupUseCase].
  const RestoreJsonBackupUseCase(this._repository);

  final BackupRepository _repository;

  /// Restores Hive modules from [filePath] and returns restored record count.
  Future<int> call(String filePath) => _repository.restoreFromJsonFile(filePath);
}
