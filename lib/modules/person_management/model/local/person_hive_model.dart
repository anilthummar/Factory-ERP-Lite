import 'package:hive_ce/hive_ce.dart';

import '../../../../core/domain/entities/person_entity.dart';
import '../../../../core/enums/sync_status.dart';
import '../../../../core/hive/hive_type_ids.dart';

part 'person_hive_model.g.dart';

/// Hive persistence model for [PersonEntity].
@HiveType(typeId: HiveTypeIds.personHiveModel)
class PersonHiveModel {
  /// Creates [PersonHiveModel].
  PersonHiveModel({
    required this.id,
    required this.createdAtMs,
    required this.updatedAtMs,
    required this.syncStatusValue,
    required this.name,
    required this.mobile,
    this.address,
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
  final String? address;

  @HiveField(7)
  final String? notes;

  /// Converts this model to a domain entity.
  PersonEntity toEntity() {
    return PersonEntity(
      id: id,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAtMs),
      syncStatus: syncStatusFromString(syncStatusValue),
      name: name,
      mobile: mobile,
      address: address,
      notes: notes,
    );
  }

  /// Creates a Hive model from [entity].
  factory PersonHiveModel.fromEntity(PersonEntity entity) {
    return PersonHiveModel(
      id: entity.id,
      createdAtMs: entity.createdAt.millisecondsSinceEpoch,
      updatedAtMs: entity.updatedAt.millisecondsSinceEpoch,
      syncStatusValue: syncStatusToString(entity.syncStatus),
      name: entity.name,
      mobile: entity.mobile,
      address: entity.address,
      notes: entity.notes,
    );
  }
}
