import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_money_v3/core/db/hive_models/category_db_model.dart';
import 'package:my_money_v3/shared/data/models/category_model.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../shared/data/models/expense_model.dart';
import 'hive_models/expense_db_model.dart';

class DatabaseHelper {
  DatabaseHelper();

  // Helper method to open a Hive box
  Future<Box<T>> _openBox<T>(String boxName) async {
    return await Hive.openBox<T>(boxName);
  }

  // Add a category to the 'categories_v2' box
  Future<String> addCategory(CategoryModel category) async {
    final categories = await _openBox<CategoryDbModel>('categories_v2');
    await categories.put(category.id, category.toDbModel());
    return category.id;
  }

  // Get all categories from the 'categories_v2' box
  Future<List<CategoryModel>> getCategories() async {
    final categories = await _openBox<CategoryDbModel>('categories_v2');
    return categories.values.map(
      (e) {
        return e.toCategoryModel();
      },
    ).toList();
  }

  // Add an expense to the 'expenses_v2' box
  Future<void> addExpanse(ExpenseModel expense) async {
    final expenses = await _openBox<ExpenseDbModel>('expenses_v2');
    await expenses.put(expense.id, expense.toDbModel());
  }

  // Delete an expense from the 'expenses_v2' box
  Future<void> deleteExpanse(String id) async {
    final expenses = await _openBox<ExpenseDbModel>('expenses_v2');
    await expenses.delete(id);
  }

  // Delete a category from the 'categories_v2' box if no expenses are associated with it
  Future<bool> deleteCategory(String id) async {
    final categories = await _openBox<CategoryDbModel>('categories_v2');
    final expenses = await _openBox<ExpenseDbModel>('expenses_v2');

    final hasAssociatedExpenses =
        expenses.values.any((expense) => expense.categoryId == id);
    if (hasAssociatedExpenses) {
      return false; // Category cannot be deleted if it has associated expenses
    }

    await categories.delete(id);
    return true;
  }

  // Get expenses, optionally filtered by date range
  Future<List<ExpenseModel>> getExpenses([int? fromDate, int? toDate]) async {
    final expenses = await _openBox<ExpenseDbModel>('expenses_v2');
    final categories = await _openBox<CategoryDbModel>('categories_v2');

    final filteredExpenses = fromDate != null
        ? expenses.values
            .where(
              (expense) => expense.date >= fromDate && expense.date < toDate!,
            )
            .toList()
        : expenses.values.toList();

    // Sort expenses by date and ID
    filteredExpenses.sort((a, b) {
      int dateComparison = b.date - a.date;
      return dateComparison != 0
          ? dateComparison
          : int.parse(b.id) - int.parse(a.id);
    });

    return filteredExpenses.map(
      (exp) {
        final category = categories.values.where(
          (cat) {
            return cat.id == exp.categoryId;
          },
        ).first;
        return exp.toExpenseModel(category.toCategoryModel());
      },
    ).toList();
  }

  // Get home dashboard information (expenses by category, today's expenses, etc.)
  Future<Map<String, dynamic>> getHomeInfo() async {
    final expenses = await _openBox<ExpenseDbModel>('expenses_v2');
    final categories = await _openBox<CategoryDbModel>('categories_v2');

    final now = Jalali.now();
    final todayStart = now
        .copy(hour: 0, minute: 0, second: 0, millisecond: 0)
        .toDateTime()
        .millisecondsSinceEpoch;
    final monthStart = now
        .copy(day: 1, hour: 0, minute: 0, second: 0, millisecond: 0)
        .toDateTime()
        .millisecondsSinceEpoch;
    final thirtyDaysAgo =
        DateTime.now().subtract(Duration(days: 30)).millisecondsSinceEpoch;
    final ninetyDaysAgo =
        DateTime.now().subtract(Duration(days: 90)).millisecondsSinceEpoch;

    // Calculate expenses by category
    final expensesByCategory = categories.values
        .map((category) {
          final categoryExpenses = expenses.values.where(
            (expense) =>
                expense.categoryId == category.id && expense.date >= monthStart,
          );
          if (categoryExpenses.isEmpty) return null;

          final totalPrice = categoryExpenses
              .map((expense) => expense.price)
              .reduce((sum, price) => sum + price);
          return {
            'title': category.title,
            'price': totalPrice,
            'color': category.color,
          };
        })
        .where((element) => element != null)
        .toList();

    // Calculate today's expenses
    final todayExpenses = expenses.values.where((expense) {
      return expense.date >= todayStart;
    });

    final todayPrice = todayExpenses.isNotEmpty
        ? todayExpenses.map((e) => e.price).reduce((sum, price) => sum + price)
        : 0;

    // Calculate monthly expenses
    final monthExpenses = expenses.values.where((expense) {
      return expense.date >= monthStart;
    });

    final monthPrice = monthExpenses.isNotEmpty
        ? monthExpenses.map((e) => e.price).reduce((sum, price) => sum + price)
        : 0;

    // Calculate expenses for the last 30 and 90 days
    final thirtyDaysExpenses =
        expenses.values.where((expense) => expense.date >= thirtyDaysAgo);
    final thirtyDaysPrice = thirtyDaysExpenses.isNotEmpty
        ? thirtyDaysExpenses
            .map((e) => e.price)
            .reduce((sum, price) => sum + price)
        : 0;

    final ninetyDaysExpenses =
        expenses.values.where((expense) => expense.date >= ninetyDaysAgo);
    final ninetyDaysPrice = ninetyDaysExpenses.isNotEmpty
        ? ninetyDaysExpenses
            .map((e) => e.price)
            .reduce((sum, price) => sum + price)
        : 0;

    return {
      'expenseByCategory': expensesByCategory,
      'todayPrice': todayPrice,
      'monthPrice': monthPrice,
      'thirtyDaysPrice': thirtyDaysPrice,
      'ninetyDaysPrice': ninetyDaysPrice,
    };
  }

  // Get a backup of all expenses with category details
  Future<List<Map<String, dynamic>>> getBackup() async {
    final expenses = await _openBox<ExpenseDbModel>('expenses_v2');
    final categories = await _openBox<CategoryDbModel>('categories_v2');

    return expenses.values.map((expense) {
      final category = categories.get(expense.categoryId);
      return {
        'title': expense.title,
        'category': category?.title ?? 'Null',
        'price': expense.price,
        'date': expense.date,
      };
    }).toList();
  }

  // Generate a report of expenses by month and category
  Future<List<Map<String, dynamic>>> getReport() async {
    final expenses = await _openBox('expenses_v2');
    final categories = await _openBox('categories_v2');

    // Sort expenses by date
    final sortedExpenses = expenses.values.toList()
      ..sort((a, b) => b['date'] - a['date']);

    // Create maps for category titles and colors
    final categoriesMap = {
      for (var category in categories.values)
        category['id'].toString(): category['title'],
    };
    final categoriesColorMap = {
      for (var category in categories.values)
        category['id'].toString(): category['color'],
    };

    // Group expenses by month and category
    final Map<String, Map<String, dynamic>> reportMap = {};
    for (var expense in sortedExpenses) {
      final jalali = Jalali.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(expense['date']),
      );
      final monthKey = '${jalali.year}/${jalali.month}';

      if (!reportMap.containsKey(monthKey)) {
        reportMap[monthKey] = {
          'monthName': monthKey,
          'sumPrice': 0,
          'catExpenseList': [],
        };
      }

      final monthData = reportMap[monthKey]!;
      monthData['sumPrice'] += expense['price'];

      final categoryId = expense['categoryId'].toString();
      final categoryExpense = monthData['catExpenseList'].firstWhere(
        (element) => element['id'] == categoryId,
        orElse: () => null,
      );

      if (categoryExpense != null) {
        categoryExpense['price'] += expense['price'];
        categoryExpense['transactionCount'] += 1;
      } else {
        monthData['catExpenseList'].add({
          'id': categoryId,
          'title': categoriesMap[categoryId],
          'transactionCount': 1,
          'color': categoriesColorMap[categoryId],
          'price': expense['price'],
        });
      }
    }

    // Calculate percentages and sort categories by price
    final reportList = reportMap.values.toList();
    for (var monthData in reportList) {
      final catExpenses = monthData['catExpenseList'] as List<dynamic>;
      for (var catExpense in catExpenses) {
        catExpense['percent'] =
            (catExpense['price'] / monthData['sumPrice']) * 100;
      }
      catExpenses.sort((a, b) => b['price'] - a['price']);
    }

    return reportList;
  }
}
