import '../../../service/network/response_handler.dart';
import '../entities/person_entity.dart';

/// Contract for person data access (domain layer only).
abstract class PersonRepository {
  /// Persists a new person record.
  Future<ResponseHandler<PersonEntity>> create(PersonEntity person);

  /// Returns a person by [id], or null if not found.
  Future<ResponseHandler<PersonEntity?>> getById(String id);

  /// Returns all person records.
  Future<ResponseHandler<List<PersonEntity>>> getAll();

  /// Updates an existing person record.
  Future<ResponseHandler<PersonEntity>> update(PersonEntity person);

  /// Deletes a person record by [id].
  Future<ResponseHandler<void>> delete(String id);

  /// Searches persons by [query] across name, mobile, address, and notes.
  Future<ResponseHandler<List<PersonEntity>>> search(String query);
}
