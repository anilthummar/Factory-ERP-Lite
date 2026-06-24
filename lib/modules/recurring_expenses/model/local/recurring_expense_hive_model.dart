import 'package:hive_ce/hive_ce.dart';

import '../../../../core/domain/entities/recurring_expense_entity.dart';
import '../../../../core/domain/enums/recurring_expense_frequency.dart';
import '../../../../core/enums/sync_status.dart';
import '../../../../core/hive/hive_type_ids.dart';

part 'recurring_expense_hive_model.g.dart';

/// Hive persistence model for [RecurringExpenseEntity].
@HiveType(typeId: HiveTypeIds.recurringExpenseHiveModel)
class RecurringExpenseHiveModel {
  /// Creates [RecurringExpenseHiveModel].
  RecurringExpenseHiveModel({
    required this.id,
    required this.createdAtMs,
    required this.updatedAtMs,
    required this.syncStatusValue,
    required this.title,
    required this.amount,
    required this.frequencyValue,
    required this.startDateMs,
    this.endDateMs,
    this.notes,
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
  final String frequencyValue;

  @HiveField(7)
  final int startDateMs;

  @HiveField(8)
  final int? endDateMs;

  @HiveField(9)
  final String? notes;

  /// Converts this model to a domain entity.
  RecurringExpenseEntity toEntity() {
    return RecurringExpenseEntity(
      id: id,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAtMs),
      syncStatus: syncStatusFromString(syncStatusValue),
      title: title,
      amount: amount,
      frequency: RecurringExpenseFrequency.values.byName(frequencyValue),
      startDate: DateTime.fromMillisecondsSinceEpoch(startDateMs),
      endDate: endDateMs == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(endDateMs!),
      notes: notes,
    );
  }

  /// Creates a Hive model from [entity].
  factory RecurringExpenseHiveModel.fromEntity(RecurringExpenseEntity entity) {
    return RecurringExpenseHiveModel(
      id: entity.id,
      createdAtMs: entity.createdAt.millisecondsSinceEpoch,
      updatedAtMs: entity.updatedAt.millisecondsSinceEpoch,
      syncStatusValue: syncStatusToString(entity.syncStatus),
      title: entity.title,
      amount: entity.amount,
      frequencyValue: entity.frequency.name,
      startDateMs: entity.startDate.millisecondsSinceEpoch,
      endDateMs: entity.endDate?.millisecondsSinceEpoch,
      notes: entity.notes,
    );
  }
}
