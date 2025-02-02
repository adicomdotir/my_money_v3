// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_db_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryDbModelAdapter extends TypeAdapter<CategoryDbModel> {
  @override
  final int typeId = 0;

  @override
  CategoryDbModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryDbModel(
      id: fields[0] as String,
      parentId: fields[1] as String,
      title: fields[2] as String,
      color: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryDbModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.parentId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryDbModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
