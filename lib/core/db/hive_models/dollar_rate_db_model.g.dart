// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dollar_rate_db_model.dart';

class DollarRateDbModelAdapter extends TypeAdapter<DollarRateDbModel> {
  @override
  final int typeId = 5;

  @override
  DollarRateDbModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DollarRateDbModel(
      year: fields[0] as int,
      month: fields[1] as int,
      price: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DollarRateDbModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.year)
      ..writeByte(1)
      ..write(obj.month)
      ..writeByte(2)
      ..write(obj.price);
  }
}
