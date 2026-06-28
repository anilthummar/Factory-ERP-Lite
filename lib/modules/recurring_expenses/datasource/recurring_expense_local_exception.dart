/// Base exception for recurring expense local storage operations.
class RecurringExpenseLocalException implements Exception {
  /// Creates [RecurringExpenseLocalException].
  const RecurringExpenseLocalException(this.message);

  /// Human-readable failure description.
  final String message;

  @override
  String toString() => 'RecurringExpenseLocalException: $message';
}

/// Thrown when a recurring expense record cannot be found in Hive.
class RecurringExpenseNotFoundException extends RecurringExpenseLocalException {
  /// Creates [RecurringExpenseNotFoundException].
  RecurringExpenseNotFoundException(String id)
      : super('Recurring expense not found for id: $id');
}

/// Thrown when creating a recurring expense with an id that already exists.
class RecurringExpenseAlreadyExistsException
    extends RecurringExpenseLocalException {
  /// Creates [RecurringExpenseAlreadyExistsException].
  RecurringExpenseAlreadyExistsException(String id)
      : super('Recurring expense already exists for id: $id');
}

/// Thrown when Hive is unavailable or a storage operation fails.
class RecurringExpenseLocalStorageException
    extends RecurringExpenseLocalException {
  /// Creates [RecurringExpenseLocalStorageException].
  const RecurringExpenseLocalStorageException(super.message);
}
