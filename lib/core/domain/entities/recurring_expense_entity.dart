import '../enums/recurring_expense_frequency.dart';
import 'syncable_entity.dart';

/// Domain entity for a recurring expense schedule.
class RecurringExpenseEntity extends SyncableEntity {
  /// Creates [RecurringExpenseEntity].
  const RecurringExpenseEntity({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.syncStatus,
    required this.title,
    required this.amount,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.notes,
  });

  /// Expense title.
  final String title;

  /// Expense amount per occurrence.
  final double amount;

  /// Billing frequency.
  final RecurringExpenseFrequency frequency;

  /// Schedule start date.
  final DateTime startDate;

  /// Optional schedule end date.
  final DateTime? endDate;

  /// Optional notes.
  final String? notes;

  @override
  List<Object?> get props => <Object?>[
        ...super.props,
        title,
        amount,
        frequency,
        startDate,
        endDate,
        notes,
      ];
}
