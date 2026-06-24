import '../../../core/domain/entities/person_entity.dart';

/// Local Hive contract for person records.
abstract class PersonLocalDataSource {
  /// Returns all person records from local storage.
  Future<List<PersonEntity>> getAllPersons();

  /// Returns a person by [id], or null when not found.
  Future<PersonEntity?> getPersonById(String id);

  /// Persists a new person record.
  ///
  /// Throws when `person.id` already exists.
  Future<PersonEntity> addPerson(PersonEntity person);

  /// Updates an existing person record.
  ///
  /// Throws when `person.id` does not exist.
  Future<PersonEntity> updatePerson(PersonEntity person);

  /// Deletes a person record by [id].
  ///
  /// Throws when `id` does not exist.
  Future<void> deletePerson(String id);

  /// Searches persons by [query] across name, mobile, address, and notes.
  Future<List<PersonEntity>> searchPersons(String query);
}
