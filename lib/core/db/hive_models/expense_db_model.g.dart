// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_db_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseDbModelAdapter extends TypeAdapter<ExpenseDbModel> {
  @override
  final int typeId = 1;

  @override
  ExpenseDbModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseDbModel(
      id: fields[0] as String,
      title: fields[1] as String,
      price: fields[2] as int,
      date: fields[3] as int,
      categoryId: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseDbModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.categoryId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseDbModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
