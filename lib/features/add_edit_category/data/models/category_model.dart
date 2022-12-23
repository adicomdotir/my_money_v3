import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required int id,
    required int parentId,
    required String title,
    required String color,
  }) : super(id: id, parentId: parentId, title: title, color: color);

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'],
        parentId: json['parentId'],
        title: json['title'],
        color: json['color'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'parentId': parentId,
        'title': title,
        'color': color,
      };
}
