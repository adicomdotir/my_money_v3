import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_money_v3/core/db/hive_models/category_db_model.dart';
import 'package:my_money_v3/core/db/hive_models/expense_db_model.dart';

Future<void> migrateData() async {
  final oldCategoriesBox = await Hive.openBox('categories');
  final oldExpensesBox = await Hive.openBox('expenses');

  final newCategoriesBox = await Hive.openBox<CategoryDbModel>('categories_v2');
  final newExpensesBox = await Hive.openBox<ExpenseDbModel>('expenses_v2');

  if (newCategoriesBox.isEmpty && newExpensesBox.isEmpty) {
    // Migrate categories
    for (var oldCategory in oldCategoriesBox.values) {
      final newCategory = CategoryDbModel(
        id: oldCategory['id'],
        title: oldCategory['title'],
        color: oldCategory['color'],
        parentId: oldCategory['parentId'],
      );
      await newCategoriesBox.put(newCategory.id, newCategory);
    }

    // Migrate expenses
    for (var oldExpense in oldExpensesBox.values) {
      final newExpense = ExpenseDbModel(
        id: oldExpense['id'],
        title: oldExpense['title'],
        price: oldExpense['price'],
        date: oldExpense['date'],
        categoryId: oldExpense['categoryId'],
      );
      await newExpensesBox.put(newExpense.id, newExpense);
    }

    print('Data migration completed!');
  } else {
    print('Data migration failed! because data migrated!!');
  }
}
