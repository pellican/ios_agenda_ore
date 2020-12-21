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
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,

    );
  }

  @override
  void write(BinaryWriter writer, Mesi obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.lavorato)
      ..writeByte(2)
      ..write(obj.pagato)
      ..writeByte(3)
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
