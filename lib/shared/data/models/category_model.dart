import 'package:my_money_v3/shared/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.parentId,
    required super.title,
    required super.color,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      parentId: json['parentId'],
      title: json['title'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'parentId': parentId,
        'title': title,
        'color': color,
      };
}
