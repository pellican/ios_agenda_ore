// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'giornate.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GiornateAdapter extends TypeAdapter<Giornate> {
  @override
  final int typeId = 1;

  @override
  Giornate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Giornate(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Giornate obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.inizio)
      ..writeByte(2)
      ..write(obj.pausa_m)
      ..writeByte(3)
      ..write(obj.fine_m)
      ..writeByte(4)
      ..write(obj.inizio_p)
      ..writeByte(5)
      ..write(obj.pausa_p)
      ..writeByte(6)
      ..write(obj.fine)
      ..writeByte(7)
      ..write(obj.totale);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GiornateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
