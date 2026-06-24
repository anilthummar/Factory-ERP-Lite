import 'package:hive_ce/hive_ce.dart';

import '../../../../core/domain/entities/factory_status_entity.dart';
import '../../../../core/domain/enums/factory_status_type.dart';
import '../../../../core/enums/sync_status.dart';
import '../../../../core/hive/hive_type_ids.dart';

part 'factory_status_hive_model.g.dart';

/// Hive persistence model for [FactoryStatusEntity].
@HiveType(typeId: HiveTypeIds.factoryStatusHiveModel)
class FactoryStatusHiveModel {
  /// Creates [FactoryStatusHiveModel].
  FactoryStatusHiveModel({
    required this.id,
    required this.createdAtMs,
    required this.updatedAtMs,
    required this.syncStatusValue,
    required this.statusValue,
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
  final String statusValue;

  @HiveField(5)
  final String? notes;

  /// Converts this model to a domain entity.
  FactoryStatusEntity toEntity() {
    return FactoryStatusEntity(
      id: id,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAtMs),
      syncStatus: syncStatusFromString(syncStatusValue),
      status: FactoryStatusType.values.byName(statusValue),
      notes: notes,
    );
  }

  /// Creates a Hive model from [entity].
  factory FactoryStatusHiveModel.fromEntity(FactoryStatusEntity entity) {
    return FactoryStatusHiveModel(
      id: entity.id,
      createdAtMs: entity.createdAt.millisecondsSinceEpoch,
      updatedAtMs: entity.updatedAt.millisecondsSinceEpoch,
      syncStatusValue: syncStatusToString(entity.syncStatus),
      statusValue: entity.status.name,
      notes: entity.notes,
    );
  }
}
