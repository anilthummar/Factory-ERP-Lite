import 'package:equatable/equatable.dart';

import '../../../core/domain/entities/recurring_expense_entity.dart';
import '../../../core/domain/enums/recurring_expense_frequency.dart';

sealed class RecurringExpenseEvent extends Equatable {
  const RecurringExpenseEvent();
  @override
  List<Object?> get props => <Object?>[];
}

final class RecurringExpenseLoadRequested extends RecurringExpenseEvent {
  const RecurringExpenseLoadRequested();
}

final class RecurringExpenseRefreshRequested extends RecurringExpenseEvent {
  const RecurringExpenseRefreshRequested();
}

final class RecurringExpenseSearchRequested extends RecurringExpenseEvent {
  const RecurringExpenseSearchRequested(this.query);
  final String query;
  @override
  List<Object?> get props => <Object?>[query];
}

final class RecurringExpenseCreateRequested extends RecurringExpenseEvent {
  const RecurringExpenseCreateRequested({
    required this.title,
    required this.amount,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.notes,
  });
  final String title;
  final double amount;
  final RecurringExpenseFrequency frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final String? notes;
  @override
  List<Object?> get props =>
      <Object?>[title, amount, frequency, startDate, endDate, notes];
}

final class RecurringExpenseUpdateRequested extends RecurringExpenseEvent {
  const RecurringExpenseUpdateRequested({
    required this.expense,
    required this.title,
    required this.amount,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.notes,
  });
  final RecurringExpenseEntity expense;
  final String title;
  final double amount;
  final RecurringExpenseFrequency frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final String? notes;
  @override
  List<Object?> get props => <Object?>[
        expense,
        title,
        amount,
        frequency,
        startDate,
        endDate,
        notes,
      ];
}

final class RecurringExpenseDeleteRequested extends RecurringExpenseEvent {
  const RecurringExpenseDeleteRequested(this.id);
  final String id;
  @override
  List<Object?> get props => <Object?>[id];
}
