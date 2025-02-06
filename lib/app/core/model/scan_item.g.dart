// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScanItemAdapter extends TypeAdapter<ScanItem> {
  @override
  final int typeId = 0;

  @override
  ScanItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScanItem(
      id: fields[0] as String,
      createdAt: fields[1] as String,
      lastScanAt: fields[2] as String,
      isError: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ScanItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.lastScanAt)
      ..writeByte(3)
      ..write(obj.isError);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
