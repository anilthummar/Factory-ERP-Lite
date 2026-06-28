// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'labor_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LaborHiveModelAdapter extends TypeAdapter<LaborHiveModel> {
  @override
  final typeId = 11;

  @override
  LaborHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LaborHiveModel(
      id: fields[0] as String,
      createdAtMs: (fields[1] as num).toInt(),
      updatedAtMs: (fields[2] as num).toInt(),
      syncStatusValue: fields[3] as String,
      name: fields[4] as String,
      mobile: fields[5] as String,
      skill: fields[6] as String,
      dailyWage: (fields[7] as num).toDouble(),
      notes: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LaborHiveModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAtMs)
      ..writeByte(2)
      ..write(obj.updatedAtMs)
      ..writeByte(3)
      ..write(obj.syncStatusValue)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.mobile)
      ..writeByte(6)
      ..write(obj.skill)
      ..writeByte(7)
      ..write(obj.dailyWage)
      ..writeByte(8)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LaborHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
