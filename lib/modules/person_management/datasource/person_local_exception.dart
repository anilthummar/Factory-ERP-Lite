/// Base exception for person local storage operations.
class PersonLocalException implements Exception {
  /// Creates [PersonLocalException].
  const PersonLocalException(this.message);

  /// Human-readable failure description.
  final String message;

  @override
  String toString() => 'PersonLocalException: $message';
}

/// Thrown when a person record cannot be found in Hive.
class PersonNotFoundException extends PersonLocalException {
  /// Creates [PersonNotFoundException].
  PersonNotFoundException(String id)
      : super('Person not found for id: $id');
}

/// Thrown when creating a person with an id that already exists.
class PersonAlreadyExistsException extends PersonLocalException {
  /// Creates [PersonAlreadyExistsException].
  PersonAlreadyExistsException(String id)
      : super('Person already exists for id: $id');
}

/// Thrown when Hive is unavailable or a storage operation fails.
class PersonLocalStorageException extends PersonLocalException {
  /// Creates [PersonLocalStorageException].
  const PersonLocalStorageException(super.message);
}
