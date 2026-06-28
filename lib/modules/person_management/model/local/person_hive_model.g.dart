// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonHiveModelAdapter extends TypeAdapter<PersonHiveModel> {
  @override
  final typeId = 10;

  @override
  PersonHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonHiveModel(
      id: fields[0] as String,
      createdAtMs: (fields[1] as num).toInt(),
      updatedAtMs: (fields[2] as num).toInt(),
      syncStatusValue: fields[3] as String,
      name: fields[4] as String,
      mobile: fields[5] as String,
      address: fields[6] as String?,
      notes: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PersonHiveModel obj) {
    writer
      ..writeByte(8)
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
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
