import 'package:my_money_v3/core/domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required String id,
    required String title,
    required String categoryId,
    required int date,
    required int price,
  }) : super(
          id: id,
          title: title,
          categoryId: categoryId,
          date: date,
          price: price,
        );

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
        id: json['id'],
        title: json['title'],
        categoryId: json['categoryId'],
        date: json['date'],
        price: json['price'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'categoryId': categoryId,
        'date': date,
        'price': price,
      };
}
