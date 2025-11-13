import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_money_v3/shared/data/models/category_model.dart';
import 'package:my_money_v3/shared/data/models/expense_model.dart';

part 'expense_db_model.g.dart';

@HiveType(typeId: 1)
class ExpenseDbModel {
  const ExpenseDbModel({
    required this.id,
    required this.title,
    required this.price,
    required this.date,
    required this.categoryId,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final int price;
  @HiveField(3)
  final int date;
  @HiveField(4)
  final String categoryId;

  ExpenseModel toExpenseModel(
    CategoryModel? categoryModel, {
    double usdPrice = 0,
  }) =>
      ExpenseModel(
        id: id,
        title: title,
        categoryId: categoryId,
        date: date,
        price: price,
        usdPrice: usdPrice,
        categoryModel: categoryModel,
      );
}

extension Mapper on ExpenseModel {
  ExpenseDbModel toDbModel() {
    return ExpenseDbModel(
      id: id,
      title: title,
      price: price,
      date: date,
      categoryId: categoryId,
    );
  }
}
