import 'package:hive_ce/hive_ce.dart';

import '../../../../core/domain/entities/expense_entity.dart';
import '../../../../core/domain/enums/expense_category.dart';
import '../../../../core/enums/sync_status.dart';
import '../../../../core/hive/hive_type_ids.dart';

part 'expense_hive_model.g.dart';

/// Hive persistence model for [ExpenseEntity].
@HiveType(typeId: HiveTypeIds.expenseHiveModel)
class ExpenseHiveModel {
  /// Creates [ExpenseHiveModel].
  ExpenseHiveModel({
    required this.id,
    required this.createdAtMs,
    required this.updatedAtMs,
    required this.syncStatusValue,
    required this.title,
    required this.amount,
    required this.dateMs,
    required this.categoryValue,
    this.notes,
    this.attachmentPath,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final int createdAtMs;

  @HiveField(2)
  final int updatedAtMs;

  @HiveField(3)
  final String syncStatusValue;

  @HiveField(4)
  final String title;

  @HiveField(5)
  final double amount;

  @HiveField(6)
  final int dateMs;

  @HiveField(7)
  final String categoryValue;

  @HiveField(8)
  final String? notes;

  @HiveField(9)
  final String? attachmentPath;

  /// Converts this model to a domain entity.
  ExpenseEntity toEntity() {
    return ExpenseEntity(
      id: id,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAtMs),
      syncStatus: syncStatusFromString(syncStatusValue),
      title: title,
      amount: amount,
      date: DateTime.fromMillisecondsSinceEpoch(dateMs),
      category: ExpenseCategory.values.byName(categoryValue),
      notes: notes,
      attachmentPath: attachmentPath,
    );
  }

  /// Creates a Hive model from [entity].
  factory ExpenseHiveModel.fromEntity(ExpenseEntity entity) {
    return ExpenseHiveModel(
      id: entity.id,
      createdAtMs: entity.createdAt.millisecondsSinceEpoch,
      updatedAtMs: entity.updatedAt.millisecondsSinceEpoch,
      syncStatusValue: syncStatusToString(entity.syncStatus),
      title: entity.title,
      amount: entity.amount,
      dateMs: entity.date.millisecondsSinceEpoch,
      categoryValue: entity.category.name,
      notes: entity.notes,
      attachmentPath: entity.attachmentPath,
    );
  }
}
