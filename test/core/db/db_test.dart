import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:my_money_v3/core/db/db.dart';
import 'package:my_money_v3/core/db/hive_models/category_db_model.dart';
import 'package:my_money_v3/core/db/hive_models/expense_db_model.dart';
import 'package:my_money_v3/shared/data/models/category_model.dart';
import 'package:my_money_v3/shared/data/models/expense_model.dart';

void main() {
  group('DatabaseHelper', () {
    late DatabaseHelper dbHelper;
    late Box<CategoryDbModel> categoriesBox;
    late Box<ExpenseDbModel> expensesBox;

    // Common test data
    final foodCategory = CategoryModel.fromMap(
      {'id': '1', 'title': 'Food', 'color': '#FF0000'},
    );
    final rentCategory = CategoryModel.fromMap(
      {'id': '2', 'title': 'Rent', 'color': '#00FF00'},
    );

    final todayExpense = ExpenseModel.fromMap({
      'categoryId': '1',
      'date': DateTime.now().millisecondsSinceEpoch,
      'price': 20,
    });
    final yesterdayExpense = ExpenseModel.fromMap({
      'categoryId': '1',
      'date': DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch,
      'price': 10,
    });
    final lastMonthExpense = ExpenseModel.fromMap({
      'categoryId': '2',
      'date':
          DateTime.now().subtract(Duration(days: 30)).millisecondsSinceEpoch,
      'price': 30,
    });

    setUp(() async {
      await setUpTestHive();
      categoriesBox = await Hive.openBox('categories_v2');
      expensesBox = await Hive.openBox('expenses_v2');
      dbHelper = DatabaseHelper();
    });

    tearDown(() async {
      await categoriesBox.clear();
      await expensesBox.clear();
      await categoriesBox.close();
      await expensesBox.close();
    });

    // Helper methods
    Future<void> seedCategories() async {
      await categoriesBox.put('1', foodCategory.toDbModel());
      await categoriesBox.put('2', rentCategory.toDbModel());
    }

    Future<void> seedExpenses() async {
      await expensesBox.put('1', todayExpense.toDbModel());
      await expensesBox.put('2', yesterdayExpense.toDbModel());
      await expensesBox.put('3', lastMonthExpense.toDbModel());
    }

    group('Category Management', () {
      test('addCategory should add a new category to the database', () async {
        await dbHelper.addCategory(foodCategory);

        expect(categoriesBox.length, 1);
        expect(categoriesBox.containsKey('1'), true);
        expect(categoriesBox.get('1'), foodCategory.toDbModel());
      });

      test('getCategories should return all categories', () async {
        await seedCategories();

        final categories = await dbHelper.getCategories();

        expect(categories.length, 2);
        expect(categories, containsAll([foodCategory, rentCategory]));
      });

      test('deleteCategory should succeed when no expenses exist', () async {
        await categoriesBox.put('1', foodCategory.toDbModel());

        final result = await dbHelper.deleteCategory('1');

        expect(result, true);
        expect(categoriesBox.containsKey('1'), false);
      });

      test('deleteCategory should fail when expenses exist', () async {
        await categoriesBox.put('1', foodCategory.toDbModel());
        await expensesBox.put('1', todayExpense.toDbModel());

        final result = await dbHelper.deleteCategory('1');

        expect(result, false);
        expect(categoriesBox.containsKey('1'), true);
      });
    });

    group('Expense Management', () {
      test('addExpanse should add a new expense', () async {
        await dbHelper.addExpanse(todayExpense);

        expect(expensesBox.containsKey('1'), true);
        expect(expensesBox.get('1'), todayExpense.toDbModel());
      });

      test('deleteExpanse should remove an expense', () async {
        await expensesBox.put('1', todayExpense.toDbModel());

        await dbHelper.deleteExpanse('1');

        expect(expensesBox.containsKey('1'), false);
      });

      test('getExpenses should return all expenses sorted by date', () async {
        await seedCategories();
        await seedExpenses();

        final expenses = await dbHelper.getExpenses();

        expect(expenses.length, 3);
        expect(expenses[0].price, todayExpense.price);
        expect(expenses[1].price, yesterdayExpense.price);
      });

      test('getExpenses should filter by date range', () async {
        await seedCategories();
        await seedExpenses();

        final fromDate =
            DateTime.now().subtract(Duration(days: 2)).millisecondsSinceEpoch;
        final toDate = DateTime.now().millisecondsSinceEpoch;
        final expenses = await dbHelper.getExpenses(fromDate, toDate);

        expect(expenses.length, 2);
      });
    });

    group('Home Screen Data', () {
      test('getHomeInfo should return summary data', () async {
        await seedCategories();
        await seedExpenses();

        final homeInfo = await dbHelper.getHomeInfo();

        expect(homeInfo['todayPrice'], todayExpense.price);
        expect(
          homeInfo['monthPrice'],
          todayExpense.price + yesterdayExpense.price,
        );
      });
    });

    group('Report Generation', () {
      test('getReport should generate monthly reports', () async {
        await seedCategories();
        await seedExpenses();

        final report = await dbHelper.getReport();

        expect(report.length, 2); // Current month and last month
        expect(
          report[0]['sumPrice'],
          todayExpense.price + yesterdayExpense.price,
        );
      });
    });
  });
}
