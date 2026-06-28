/// Base exception for labor local storage operations.
class LaborLocalException implements Exception {
  /// Creates [LaborLocalException].
  const LaborLocalException(this.message);

  /// Human-readable failure description.
  final String message;

  @override
  String toString() => 'LaborLocalException: $message';
}

/// Thrown when a labor record cannot be found in Hive.
class LaborNotFoundException extends LaborLocalException {
  /// Creates [LaborNotFoundException].
  LaborNotFoundException(String id) : super('Labor not found for id: $id');
}

/// Thrown when creating labor with an id that already exists.
class LaborAlreadyExistsException extends LaborLocalException {
  /// Creates [LaborAlreadyExistsException].
  LaborAlreadyExistsException(String id) : super('Labor already exists for id: $id');
}

/// Thrown when Hive is unavailable or a storage operation fails.
class LaborLocalStorageException extends LaborLocalException {
  /// Creates [LaborLocalStorageException].
  const LaborLocalStorageException(super.message);
}
