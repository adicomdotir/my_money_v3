import 'package:my_money_v3/features/home/domain/entities/expense_by_category_entity.dart';

class ExpenseByCategoryModel extends ExpenseByCategoryEntity {
  const ExpenseByCategoryModel({
    required String title,
    required int price,
    required String color,
  }) : super(title: title, price: price, color: color);

  factory ExpenseByCategoryModel.fromJson(Map<String, dynamic> json) =>
      ExpenseByCategoryModel(
        title: json['title'],
        price: json['price'],
        color: json['color'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'price': price,
        'color': color,
      };
}
