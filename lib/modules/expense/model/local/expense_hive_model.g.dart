// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseHiveModelAdapter extends TypeAdapter<ExpenseHiveModel> {
  @override
  final typeId = 12;

  @override
  ExpenseHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseHiveModel(
      id: fields[0] as String,
      createdAtMs: (fields[1] as num).toInt(),
      updatedAtMs: (fields[2] as num).toInt(),
      syncStatusValue: fields[3] as String,
      title: fields[4] as String,
      amount: (fields[5] as num).toDouble(),
      dateMs: (fields[6] as num).toInt(),
      categoryValue: fields[7] as String,
      notes: fields[8] as String?,
      attachmentPath: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAtMs)
      ..writeByte(2)
      ..write(obj.updatedAtMs)
      ..writeByte(3)
      ..write(obj.syncStatusValue)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.amount)
      ..writeByte(6)
      ..write(obj.dateMs)
      ..writeByte(7)
      ..write(obj.categoryValue)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.attachmentPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
