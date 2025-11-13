import 'package:my_money_v3/shared/data/models/category_model.dart';
import 'package:my_money_v3/shared/domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required super.id,
    required super.title,
    required super.categoryId,
    required super.date,
    required super.price,
    super.usdPrice = 0,
    CategoryModel? categoryModel,
  }) : super(
          category: categoryModel,
        );

  factory ExpenseModel.fromMap(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      categoryId: json['categoryId'] as String,
      date: json['date'] as int,
      price: json['price'] as int,
      usdPrice: (json['usdPrice'] as num?)?.toDouble() ?? 0,
      categoryModel:
          CategoryModel.fromMap(json['category'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'categoryId': categoryId,
        'date': date,
        'price': price,
        'usdPrice': usdPrice,
      };
}
