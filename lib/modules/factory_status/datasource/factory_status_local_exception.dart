/// Base exception for factory status local storage failures.
class FactoryStatusLocalException implements Exception {
  /// Creates [FactoryStatusLocalException].
  const FactoryStatusLocalException(this.message);

  /// Human-readable failure description.
  final String message;

  @override
  String toString() => 'FactoryStatusLocalException: $message';
}

/// Thrown when a factory status record is not found.
class FactoryStatusNotFoundException extends FactoryStatusLocalException {
  /// Creates [FactoryStatusNotFoundException].
  FactoryStatusNotFoundException(String id)
      : super('Factory status record not found: $id');
}

/// Thrown when Hive is unavailable for factory status storage.
class FactoryStatusLocalStorageException extends FactoryStatusLocalException {
  /// Creates [FactoryStatusLocalStorageException].
  const FactoryStatusLocalStorageException(super.message);
}
