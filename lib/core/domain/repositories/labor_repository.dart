import '../entities/labor_entity.dart';

/// Contract for labor data access (domain layer only).
abstract class LaborRepository {
  /// Persists a new labor record.
  Future<LaborEntity> create(LaborEntity labor);

  /// Returns a labor record by [id], or null if not found.
  Future<LaborEntity?> getById(String id);

  /// Returns all labor records.
  Future<List<LaborEntity>> getAll();

  /// Updates an existing labor record.
  Future<LaborEntity> update(LaborEntity labor);

  /// Deletes a labor record by [id].
  Future<void> delete(String id);
}
