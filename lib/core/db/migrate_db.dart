import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_money_v3/core/db/hive_models/category_db_model.dart';
import 'package:my_money_v3/core/db/hive_models/expense_db_model.dart';

Future<void> migrateData() async {
  final oldCategoriesBox = await Hive.openBox<dynamic>('categories');
  final oldExpensesBox = await Hive.openBox<dynamic>('expenses');

  final newCategoriesBox = await Hive.openBox<CategoryDbModel>('categories_v2');
  final newExpensesBox = await Hive.openBox<ExpenseDbModel>('expenses_v2');

  if (newCategoriesBox.isEmpty && newExpensesBox.isEmpty) {
    // Migrate categories
    for (var oldCategory in oldCategoriesBox.values) {
      final newCategory = CategoryDbModel(
        id: oldCategory['id'] as String,
        title: oldCategory['title'] as String,
        color: oldCategory['color'] as String,
        parentId: oldCategory['parentId'] as String,
      );
      await newCategoriesBox.put(newCategory.id, newCategory);
    }

    // Migrate expenses
    for (var oldExpense in oldExpensesBox.values) {
      final newExpense = ExpenseDbModel(
        id: oldExpense['id'] as String,
        title: oldExpense['title'] as String,
        price: oldExpense['price'] as int,
        date: oldExpense['date'] as int,
        categoryId: oldExpense['categoryId'] as String,
      );
      await newExpensesBox.put(newExpense.id, newExpense);
    }

    oldExpensesBox.close();
    oldCategoriesBox.close();
    newExpensesBox.close();
    newCategoriesBox.close();
    debugPrint('Data migration completed!');
  } else {
    oldExpensesBox.close();
    oldCategoriesBox.close();
    newExpensesBox.close();
    newCategoriesBox.close();
    debugPrint('Data migration failed! because data migrated!!');
  }
}
