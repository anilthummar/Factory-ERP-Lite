import '../../../../core/domain/entities/factory_status_entity.dart';
import '../../../../core/domain/enums/factory_status_type.dart';
import '../../../../core/domain/repositories/factory_status_repository.dart';
import '../../../../core/enums/sync_status.dart';

/// Persists a new factory status change to Hive history.
class ChangeFactoryStatusUseCase {
  /// Creates [ChangeFactoryStatusUseCase].
  const ChangeFactoryStatusUseCase(this._repository);

  final FactoryStatusRepository _repository;

  /// Appends a status change with [status] and optional [notes].
  Future<FactoryStatusEntity> call({
    required FactoryStatusType status,
    String? notes,
  }) async {
    final DateTime now = DateTime.now();
    final String? trimmedNotes = notes?.trim();
    final FactoryStatusEntity entity = FactoryStatusEntity(
      id: 'factory_status_${now.microsecondsSinceEpoch}',
      createdAt: now,
      updatedAt: now,
      syncStatus: SyncStatus.pending,
      status: status,
      notes: trimmedNotes == null || trimmedNotes.isEmpty ? null : trimmedNotes,
    );
    return _repository.changeStatus(status: entity);
  }
}
