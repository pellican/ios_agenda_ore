// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datamesi.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MesiAdapter extends TypeAdapter<Mesi> {
  @override
  final int typeId = 2;

  @override
  Mesi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Mesi(
      fields[0] as String,
      fields[1] as int,
      fields[2] as int,
      fields[3] as String,
      fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Mesi obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.anno)
      ..writeByte(1)
      ..write(obj.ore)
      ..writeByte(2)
      ..write(obj.min)
      ..writeByte(3)
      ..write(obj.pagato)
      ..writeByte(4)
      ..write(obj.resto);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MesiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
