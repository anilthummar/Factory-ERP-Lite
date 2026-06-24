// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_expense_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecurringExpenseHiveModelAdapter
    extends TypeAdapter<RecurringExpenseHiveModel> {
  @override
  final typeId = 13;

  @override
  RecurringExpenseHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecurringExpenseHiveModel(
      id: fields[0] as String,
      createdAtMs: (fields[1] as num).toInt(),
      updatedAtMs: (fields[2] as num).toInt(),
      syncStatusValue: fields[3] as String,
      title: fields[4] as String,
      amount: (fields[5] as num).toDouble(),
      frequencyValue: fields[6] as String,
      startDateMs: (fields[7] as num).toInt(),
      endDateMs: (fields[8] as num?)?.toInt(),
      notes: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RecurringExpenseHiveModel obj) {
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
      ..write(obj.frequencyValue)
      ..writeByte(7)
      ..write(obj.startDateMs)
      ..writeByte(8)
      ..write(obj.endDateMs)
      ..writeByte(9)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurringExpenseHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
