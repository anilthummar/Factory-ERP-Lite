import '../../../core/domain/entities/factory_status_entity.dart';

/// Local Hive contract for factory status history records.
abstract class FactoryStatusLocalDataSource {
  /// Returns all status history records, newest first.
  Future<List<FactoryStatusEntity>> getAll();

  /// Returns a status record by [id], or null when not found.
  Future<FactoryStatusEntity?> getById(String id);

  /// Persists a new status history record.
  Future<FactoryStatusEntity> add(FactoryStatusEntity status);

  /// Updates an existing status record.
  Future<FactoryStatusEntity> update(FactoryStatusEntity status);

  /// Deletes a status record by [id].
  Future<void> delete(String id);
}
