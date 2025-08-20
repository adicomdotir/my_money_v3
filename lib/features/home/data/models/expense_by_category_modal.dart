import 'package:my_money_v3/features/home/domain/entities/expense_by_category_entity.dart';

class ExpenseByCategoryModel extends ExpenseByCategoryEntity {
  const ExpenseByCategoryModel({
    required super.title,
    required super.price,
    required super.color,
    required super.id,
  });

  factory ExpenseByCategoryModel.fromMap(Map<String, dynamic> json) =>
      ExpenseByCategoryModel(
        title: json['title'] as String,
        price: json['price'] as int,
        color: json['color'] as String,
        id: json['id'] as String,
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'price': price,
        'color': color,
        'id': id,
      };
}
