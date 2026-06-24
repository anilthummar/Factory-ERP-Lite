import '../../domain/models/backup_file_result.dart';
import '../../repository/backup_repository.dart';

/// Creates a JSON backup and shares it.
class CreateJsonBackupUseCase {
  /// Creates [CreateJsonBackupUseCase].
  const CreateJsonBackupUseCase(this._repository);

  final BackupRepository _repository;

  /// Exports Hive data to JSON, saves locally, and opens share sheet.
  Future<BackupFileResult> call() => _repository.createAndShareJsonBackup();
}
