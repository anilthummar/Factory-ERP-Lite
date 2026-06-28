import 'package:equatable/equatable.dart';

import '../../../core/domain/entities/expense_entity.dart';

/// Base events for module-scoped expense BLoCs.
sealed class ExpenseModuleEvent extends Equatable {
  /// Creates [ExpenseModuleEvent].
  const ExpenseModuleEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Loads all expenses from local storage.
final class ExpenseModuleLoadRequested extends ExpenseModuleEvent {
  /// Creates [ExpenseModuleLoadRequested].
  const ExpenseModuleLoadRequested();
}

/// Reloads expenses (pull-to-refresh).
final class ExpenseModuleRefreshRequested extends ExpenseModuleEvent {
  /// Creates [ExpenseModuleRefreshRequested].
  const ExpenseModuleRefreshRequested();
}

/// Searches expenses by [query].
final class ExpenseModuleSearchRequested extends ExpenseModuleEvent {
  /// Creates [ExpenseModuleSearchRequested].
  const ExpenseModuleSearchRequested(this.query);

  /// Search text.
  final String query;

  @override
  List<Object?> get props => <Object?>[query];
}

/// Creates a new expense record.
final class ExpenseModuleCreateRequested extends ExpenseModuleEvent {
  /// Creates [ExpenseModuleCreateRequested].
  const ExpenseModuleCreateRequested({
    required this.title,
    required this.amount,
    required this.date,
    this.notes,
    this.attachmentPath,
  });

  /// Expense title.
  final String title;

  /// Expense amount.
  final double amount;

  /// Expense date.
  final DateTime date;

  /// Optional notes.
  final String? notes;

  /// Optional attachment path.
  final String? attachmentPath;

  @override
  List<Object?> get props =>
      <Object?>[title, amount, date, notes, attachmentPath];
}

/// Updates an existing expense record.
final class ExpenseModuleUpdateRequested extends ExpenseModuleEvent {
  /// Creates [ExpenseModuleUpdateRequested].
  const ExpenseModuleUpdateRequested({
    required this.expense,
    required this.title,
    required this.amount,
    required this.date,
    this.notes,
    this.attachmentPath,
  });

  /// Existing expense record.
  final ExpenseEntity expense;

  /// Updated title.
  final String title;

  /// Updated amount.
  final double amount;

  /// Updated date.
  final DateTime date;

  /// Updated notes.
  final String? notes;

  /// Updated attachment path.
  final String? attachmentPath;

  @override
  List<Object?> get props => <Object?>[
        expense,
        title,
        amount,
        date,
        notes,
        attachmentPath,
      ];
}

/// Deletes an expense record by [id].
final class ExpenseModuleDeleteRequested extends ExpenseModuleEvent {
  /// Creates [ExpenseModuleDeleteRequested].
  const ExpenseModuleDeleteRequested(this.id);

  /// Expense identifier.
  final String id;

  @override
  List<Object?> get props => <Object?>[id];
}
