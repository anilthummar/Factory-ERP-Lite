// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'factory_status_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FactoryStatusHiveModelAdapter
    extends TypeAdapter<FactoryStatusHiveModel> {
  @override
  final typeId = 14;

  @override
  FactoryStatusHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FactoryStatusHiveModel(
      id: fields[0] as String,
      createdAtMs: (fields[1] as num).toInt(),
      updatedAtMs: (fields[2] as num).toInt(),
      syncStatusValue: fields[3] as String,
      statusValue: fields[4] as String,
      notes: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FactoryStatusHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAtMs)
      ..writeByte(2)
      ..write(obj.updatedAtMs)
      ..writeByte(3)
      ..write(obj.syncStatusValue)
      ..writeByte(4)
      ..write(obj.statusValue)
      ..writeByte(5)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FactoryStatusHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
