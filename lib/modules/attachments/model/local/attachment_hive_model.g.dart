// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttachmentHiveModelAdapter extends TypeAdapter<AttachmentHiveModel> {
  @override
  final typeId = 15;

  @override
  AttachmentHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttachmentHiveModel(
      id: fields[0] as String,
      createdAtMs: (fields[1] as num).toInt(),
      updatedAtMs: (fields[2] as num).toInt(),
      syncStatusValue: fields[3] as String,
      fileName: fields[4] as String,
      localPath: fields[5] as String,
      mimeType: fields[6] as String,
      fileSizeBytes: (fields[7] as num).toInt(),
      attachmentTypeValue: fields[8] as String,
      parentModuleValue: fields[9] as String?,
      parentRecordId: fields[10] as String?,
      downloadUrl: fields[11] as String?,
      storagePath: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AttachmentHiveModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAtMs)
      ..writeByte(2)
      ..write(obj.updatedAtMs)
      ..writeByte(3)
      ..write(obj.syncStatusValue)
      ..writeByte(4)
      ..write(obj.fileName)
      ..writeByte(5)
      ..write(obj.localPath)
      ..writeByte(6)
      ..write(obj.mimeType)
      ..writeByte(7)
      ..write(obj.fileSizeBytes)
      ..writeByte(8)
      ..write(obj.attachmentTypeValue)
      ..writeByte(9)
      ..write(obj.parentModuleValue)
      ..writeByte(10)
      ..write(obj.parentRecordId)
      ..writeByte(11)
      ..write(obj.downloadUrl)
      ..writeByte(12)
      ..write(obj.storagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttachmentHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
