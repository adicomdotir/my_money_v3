import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required int id,
    required String title,
    required String color,
  }) : super(id: id, title: title, color: color);

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'],
        title: json['title'],
        color: json['color'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'color': color,
      };
}
