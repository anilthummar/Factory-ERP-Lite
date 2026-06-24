import '../../../core/domain/entities/labor_entity.dart';

/// Local Hive contract for labor records.
abstract class LaborLocalDataSource {
  /// Returns all labor records from local storage.
  Future<List<LaborEntity>> getAllLabor();

  /// Returns a labor record by [id], or null when not found.
  Future<LaborEntity?> getLaborById(String id);

  /// Persists a new labor record.
  ///
  /// Throws when `labor.id` already exists.
  Future<LaborEntity> addLabor(LaborEntity labor);

  /// Updates an existing labor record.
  ///
  /// Throws when `labor.id` does not exist.
  Future<LaborEntity> updateLabor(LaborEntity labor);

  /// Deletes a labor record by [id].
  ///
  /// Throws when `id` does not exist.
  Future<void> deleteLabor(String id);

  /// Searches labor records by [query] across name, mobile, skill, and notes.
  Future<List<LaborEntity>> searchLabor(String query);
}
