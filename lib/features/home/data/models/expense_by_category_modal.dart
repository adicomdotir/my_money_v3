import 'package:my_money_v3/features/home/domain/entities/expense_by_category_entity.dart';

class ExpenseByCategoryModel extends ExpenseByCategoryEntity {
  const ExpenseByCategoryModel({
    required super.title,
    required super.price,
    required super.color,
  });

  factory ExpenseByCategoryModel.fromMap(Map<String, dynamic> json) =>
      ExpenseByCategoryModel(
        title: json['title'],
        price: json['price'],
        color: json['color'],
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'price': price,
        'color': color,
      };
}
