import 'package:my_money_v3/shared/data/models/category_model.dart';
import 'package:my_money_v3/shared/domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required super.id,
    required super.title,
    required super.categoryId,
    required super.date,
    required super.price,
    CategoryModel? categoryModel,
  }) : super(
          category: categoryModel,
        );

  factory ExpenseModel.fromMap(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      title: json['title'],
      categoryId: json['categoryId'],
      date: json['date'],
      price: json['price'],
      categoryModel: CategoryModel.fromMap(json['category']),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'categoryId': categoryId,
        'date': date,
        'price': price,
      };
}
