/// Base exception for expense local storage operations.
class ExpenseLocalException implements Exception {
  /// Creates [ExpenseLocalException].
  const ExpenseLocalException(this.message);

  /// Human-readable failure description.
  final String message;

  @override
  String toString() => 'ExpenseLocalException: $message';
}

/// Thrown when an expense record cannot be found in Hive.
class ExpenseNotFoundException extends ExpenseLocalException {
  /// Creates [ExpenseNotFoundException].
  ExpenseNotFoundException(String id) : super('Expense not found for id: $id');
}

/// Thrown when creating an expense with an id that already exists.
class ExpenseAlreadyExistsException extends ExpenseLocalException {
  /// Creates [ExpenseAlreadyExistsException].
  ExpenseAlreadyExistsException(String id)
      : super('Expense already exists for id: $id');
}

/// Thrown when Hive is unavailable or a storage operation fails.
class ExpenseLocalStorageException extends ExpenseLocalException {
  /// Creates [ExpenseLocalStorageException].
  const ExpenseLocalStorageException(super.message);
}
