import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:my_money_v3/core/db/db.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

void main() {
  group('DatabaseHelper', () {
    late DatabaseHelper dbHelper;
    late Box<dynamic> categoriesBox;
    late Box<dynamic> expensesBox;

    setUp(() async {
      // await Hive.initFlutter();
      await setUpTestHive();
      categoriesBox = await Hive.openBox('categories');
      expensesBox = await Hive.openBox('expenses');
      dbHelper = DatabaseHelper();
    });

    tearDown(() async {
      await categoriesBox.clear();
      await expensesBox.clear();
      await categoriesBox.close();
      await expensesBox.close();
    });

    group('Category Management', () {
      test('addCategory should add a new category to the database', () async {
        final categoryJson = {'title': 'Food', 'color': '#FF0000'};
        final id = '1';

        await dbHelper.addCategory(categoryJson, id);
        expect(categoriesBox.length, 1);
        expect(categoriesBox.containsKey(id), true);
        expect(categoriesBox.get(id), categoryJson);
      });

      test('getCategories should return a list of all categories', () async {
        final category1 = {'title': 'Food', 'color': '#FF0000'};
        final category2 = {'title': 'Rent', 'color': '#00FF00'};
        await categoriesBox.put('1', category1);
        await categoriesBox.put('2', category2);

        final categories = await dbHelper.getCategories();

        expect(categories.length, 2);
        expect(categories.contains(category1), true);
        expect(categories.contains(category2), true);
      });

      test(
          'deleteCategory should delete a category from the database if no expenses are associated',
          () async {
        final categoryId = '1';
        await categoriesBox
            .put(categoryId, {'title': 'Food', 'color': '#FF0000'});

        final result = await dbHelper.deleteCategory(categoryId);

        expect(result, true);
        expect(categoriesBox.containsKey(categoryId), false);
      });

      test(
          'deleteCategory should not delete a category if expenses are associated',
          () async {
        final categoryId = '1';
        await categoriesBox
            .put(categoryId, {'title': 'Food', 'color': '#FF0000'});
        await expensesBox.put(
          '1',
          {'categoryId': categoryId, 'date': 123, 'price': 10},
        );

        final result = await dbHelper.deleteCategory(categoryId);

        expect(result, false);
        expect(categoriesBox.containsKey(categoryId), true);
      });
    });

    group('Expense Management', () {
      test('addExpanse should add a new expense to the database', () async {
        final expenseJson = {
          'categoryId': '1',
          'date': 1678886400000,
          'price': 10,
        };
        final id = '1';

        await dbHelper.addExpanse(expenseJson, id);

        expect(expensesBox.containsKey(id), true);
        expect(expensesBox.get(id), expenseJson);
      });

      test('deleteExpanse should delete an expense from the database',
          () async {
        final expenseId = '1';
        await expensesBox.put(expenseId, {
          'categoryId': '1',
          'date': 1678886400000,
          'price': 10,
        });

        await dbHelper.deleteExpanse(expenseId);

        expect(expensesBox.containsKey(expenseId), false);
      });

      test('getExpenses should return a list of all expenses', () async {
        final expense1 = {
          'categoryId': '1',
          'date': 1678886400000,
          'price': 10,
        };
        final expense2 = {
          'categoryId': '2',
          'date': 1678972800000,
          'price': 20,
        };
        await expensesBox.put('1', expense1);
        await expensesBox.put('2', expense2);
        await categoriesBox.put('1', {'title': 'Food', 'color': '#FF0000'});
        await categoriesBox.put('2', {'title': 'Rent', 'color': '#00FF00'});

        final expenses = await dbHelper.getExpenses();

        expect(expenses.length, 2);
        expect(expenses[0]['price'], 20);
        expect(expenses[1]['price'], 10);
      });

      test('getExpenses should filter expenses by date range', () async {
        final expense1 = {
          'categoryId': '1',
          'date': 1678886400000,
          'price': 10,
        };
        final expense2 = {
          'categoryId': '2',
          'date': 1678972800000,
          'price': 20,
        };
        await expensesBox.put('1', expense1);
        await expensesBox.put('2', expense2);
        await categoriesBox.put('1', {'title': 'Food', 'color': '#FF0000'});
        await categoriesBox.put('2', {'title': 'Rent', 'color': '#00FF00'});

        final fromDate = 1678929200000;
        final toDate = 1679016000000;
        final expenses = await dbHelper.getExpenses(fromDate, toDate);

        expect(expenses.length, 1);
        expect(expenses[0]['price'], 20);
      });
    });

    group('Home Screen Data', () {
      test('getHomeInfo should return summary data for the home screen',
          () async {
        final category1 = {'id': '1', 'title': 'Food', 'color': '#FF0000'};
        final category2 = {'id': '2', 'title': 'Rent', 'color': '#00FF00'};
        await categoriesBox.put('1', category1);
        await categoriesBox.put('2', category2);
        final now = Jalali.now();
        final thisMonth = now.copy(day: 1);
        final today = now.copy(hour: 0, minute: 0, second: 0);
        final expense1 = {
          'categoryId': '1',
          'date': today
              .copy(day: today.day - 1)
              .toDateTime()
              .millisecondsSinceEpoch,
          'price': 10,
        };
        final expense2 = {
          'categoryId': '2',
          'date': today.toDateTime().millisecondsSinceEpoch,
          'price': 20,
        };
        final expense3 = {
          'categoryId': '1',
          'date': thisMonth
              .copy(month: thisMonth.month - 1)
              .toDateTime()
              .millisecondsSinceEpoch,
          'price': 30,
        };
        await expensesBox.put('1', expense1);
        await expensesBox.put('2', expense2);
        await expensesBox.put('3', expense3);

        final homeInfo = await dbHelper.getHomeInfo();

        expect(homeInfo['expenseByCategory'].length, 2);
        expect(homeInfo['expenseByCategory'][0]['price'], 20);
        expect(homeInfo['expenseByCategory'][1]['price'], 10);
        expect(homeInfo['todayPrice'], 20);
        expect(homeInfo['monthPrice'], 30);
        expect(homeInfo['thirtyDaysPrice'], 50);
        expect(homeInfo['ninetyDaysPrice'], 80);
      });
    });

    group('Report Generation', () {
      test('getReport should generate a monthly expense report', () async {
        final category1 = {'id': '1', 'title': 'Food', 'color': '#FF0000'};
        final category2 = {'id': '2', 'title': 'Rent', 'color': '#00FF00'};
        await categoriesBox.put('1', category1);
        await categoriesBox.put('2', category2);
        final now = Jalali.now();
        final thisMonth = now.copy(day: 1);
        final expense1 = {
          'categoryId': '1',
          'date': thisMonth
              .copy(month: thisMonth.month - 2)
              .toDateTime()
              .millisecondsSinceEpoch,
          'price': 10,
        };
        final expense2 = {
          'categoryId': '2',
          'date': thisMonth
              .copy(month: thisMonth.month - 1)
              .toDateTime()
              .millisecondsSinceEpoch,
          'price': 20,
        };
        final expense3 = {
          'categoryId': '1',
          'date': thisMonth.toDateTime().millisecondsSinceEpoch,
          'price': 30,
        };
        await expensesBox.put('1', expense1);
        await expensesBox.put('2', expense2);
        await expensesBox.put('3', expense3);

        final report = await dbHelper.getReport();

        expect(report.length, 3);
        expect(report[0]['monthName'], '${thisMonth.year}/${thisMonth.month}');
        expect(report[0]['sumPrice'], 30);
        expect(report[0]['catExpenseList'].length, 1);
        expect(
          report[1]['monthName'],
          '${thisMonth.copy(month: thisMonth.month - 1).year}/${thisMonth.copy(month: thisMonth.month - 1).month}',
        );
        expect(report[1]['sumPrice'], 20);
        expect(report[1]['catExpenseList'].length, 1);
        expect(
          report[2]['monthName'],
          '${thisMonth.copy(month: thisMonth.month - 2).year}/${thisMonth.copy(month: thisMonth.month - 2).month}',
        );
        expect(report[2]['sumPrice'], 10);
        expect(report[2]['catExpenseList'].length, 1);
      });
    });
  });
}
