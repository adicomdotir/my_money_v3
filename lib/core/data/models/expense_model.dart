import 'package:my_money_v3/core/data/models/category_model.dart';
import 'package:my_money_v3/core/domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required String id,
    required String title,
    required String categoryId,
    required int date,
    required int price,
    CategoryModel? categoryModel,
  }) : super(
          id: id,
          title: title,
          categoryId: categoryId,
          date: date,
          price: price,
          category: categoryModel,
        );

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      title: json['title'],
      categoryId: json['categoryId'],
      date: json['date'],
      price: json['price'],
      categoryModel: CategoryModel.fromJson(json['category']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'categoryId': categoryId,
        'date': date,
        'price': price,
      };
}
