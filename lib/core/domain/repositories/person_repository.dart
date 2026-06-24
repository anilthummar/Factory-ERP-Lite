import '../entities/person_entity.dart';

/// Contract for person data access (domain layer only).
abstract class PersonRepository {
  /// Persists a new person record.
  Future<PersonEntity> create(PersonEntity person);

  /// Returns a person by [id], or null if not found.
  Future<PersonEntity?> getById(String id);

  /// Returns all person records.
  Future<List<PersonEntity>> getAll();

  /// Updates an existing person record.
  Future<PersonEntity> update(PersonEntity person);

  /// Deletes a person record by [id].
  Future<void> delete(String id);
}
