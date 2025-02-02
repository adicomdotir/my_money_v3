import 'package:hive_flutter/hive_flutter.dart';

import '../../../shared/data/models/category_model.dart';

part 'category_db_model.g.dart';

@HiveType(typeId: 0)
class CategoryDbModel {
  const CategoryDbModel({
    required this.id,
    required this.parentId,
    required this.title,
    required this.color,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String parentId;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String color;

  CategoryModel toCategoryModel() =>
      CategoryModel(id: id, parentId: parentId, title: title, color: color);
}

extension Mapper on CategoryModel {
  CategoryDbModel toDbModel() {
    return CategoryDbModel(
      id: id,
      parentId: parentId,
      title: title,
      color: color,
    );
  }
}
