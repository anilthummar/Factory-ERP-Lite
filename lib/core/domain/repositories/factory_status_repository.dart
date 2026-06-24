import '../entities/factory_status_entity.dart';

/// Contract for factory status data access (domain layer only).
abstract class FactoryStatusRepository {
  /// Persists a new factory status record.
  Future<FactoryStatusEntity> create(FactoryStatusEntity status);

  /// Returns a factory status record by [id], or null if not found.
  Future<FactoryStatusEntity?> getById(String id);

  /// Returns all factory status records.
  Future<List<FactoryStatusEntity>> getAll();

  /// Updates an existing factory status record.
  Future<FactoryStatusEntity> update(FactoryStatusEntity status);

  /// Deletes a factory status record by [id].
  Future<void> delete(String id);
}
