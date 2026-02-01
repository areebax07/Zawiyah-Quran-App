// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tasbih_item.dart';

class TasbihItemAdapter extends TypeAdapter<TasbihItem> {
  @override
  final int typeId = 2;

  @override
  TasbihItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TasbihItem(
      arabicText: fields[0] as String,
      transliteration: fields[1] as String,
      count: fields[2] as int,
      targetCount: fields[3] as int,
      totalCount: fields[4] as int,
      cumulativeCount: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TasbihItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.arabicText)
      ..writeByte(1)
      ..write(obj.transliteration)
      ..writeByte(2)
      ..write(obj.count)
      ..writeByte(3)
      ..write(obj.targetCount)
      ..writeByte(4)
      ..write(obj.totalCount)
      ..writeByte(5)
      ..write(obj.cumulativeCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TasbihItemAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
