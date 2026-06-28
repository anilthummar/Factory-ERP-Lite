import 'package:hive_ce/hive_ce.dart';

import '../../../../core/domain/entities/labor_entity.dart';
import '../../../../core/enums/sync_status.dart';
import '../../../../core/hive/hive_type_ids.dart';

part 'labor_hive_model.g.dart';

/// Hive persistence model for [LaborEntity].
@HiveType(typeId: HiveTypeIds.laborHiveModel)
class LaborHiveModel {
  /// Creates [LaborHiveModel].
  LaborHiveModel({
    required this.id,
    required this.createdAtMs,
    required this.updatedAtMs,
    required this.syncStatusValue,
    required this.name,
    required this.mobile,
    required this.skill,
    required this.dailyWage,
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
  final String name;

  @HiveField(5)
  final String mobile;

  @HiveField(6)
  final String skill;

  @HiveField(7)
  final double dailyWage;

  @HiveField(8)
  final String? notes;

  /// Converts this model to a domain entity.
  LaborEntity toEntity() {
    return LaborEntity(
      id: id,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAtMs),
      syncStatus: syncStatusFromString(syncStatusValue),
      name: name,
      mobile: mobile,
      skill: skill,
      dailyWage: dailyWage,
      notes: notes,
    );
  }

  /// Creates a Hive model from [entity].
  factory LaborHiveModel.fromEntity(LaborEntity entity) {
    return LaborHiveModel(
      id: entity.id,
      createdAtMs: entity.createdAt.millisecondsSinceEpoch,
      updatedAtMs: entity.updatedAt.millisecondsSinceEpoch,
      syncStatusValue: syncStatusToString(entity.syncStatus),
      name: entity.name,
      mobile: entity.mobile,
      skill: entity.skill,
      dailyWage: entity.dailyWage,
      notes: entity.notes,
    );
  }
}
