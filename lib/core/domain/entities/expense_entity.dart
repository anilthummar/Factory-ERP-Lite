import '../enums/expense_category.dart';
import 'syncable_entity.dart';

/// Domain entity for a one-time expense record.
class ExpenseEntity extends SyncableEntity {
  /// Creates [ExpenseEntity].
  const ExpenseEntity({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required super.syncStatus,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.notes,
    this.attachmentPath,
  });

  /// Expense title.
  final String title;

  /// Expense amount.
  final double amount;

  /// Expense date.
  final DateTime date;

  /// Expense module category.
  final ExpenseCategory category;

  /// Optional notes.
  final String? notes;

  /// Optional local or remote attachment path.
  final String? attachmentPath;

  @override
  List<Object?> get props => <Object?>[
        ...super.props,
        title,
        amount,
        date,
        category,
        notes,
        attachmentPath,
      ];
}
