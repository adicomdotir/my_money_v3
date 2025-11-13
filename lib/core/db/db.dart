import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_money_v3/core/db/hive_models/category_db_model.dart';
import 'package:my_money_v3/shared/data/models/category_model.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../features/dollar_rate/data/models/dollar_rate_model.dart';
import '../../shared/data/models/expense_model.dart';
import 'hive_models/dollar_rate_db_model.dart';
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

  // Dollar rates
  Future<void> upsertDollarRate(DollarRateModel rate) async {
    final box = await _openBox<DollarRateDbModel>('dollar_rates_v1');
    await box.put('${rate.year}-${rate.month}', rate.toDbModel());
  }

  Future<DollarRateModel?> getDollarRate(int year, int month) async {
    final box = await _openBox<DollarRateDbModel>('dollar_rates_v1');
    final v = box.get('$year-$month');
    return v?.toModel();
  }

  Future<List<DollarRateModel>> getAllDollarRates() async {
    final box = await _openBox<DollarRateDbModel>('dollar_rates_v1');
    return box.values.map((e) => e.toModel()).toList()
      ..sort((a, b) {
        if (a.year != b.year) return b.year.compareTo(a.year);
        return b.month.compareTo(a.month);
      });
  }

  Future<void> deleteDollarRate(int year, int month) async {
    final box = await _openBox<DollarRateDbModel>('dollar_rates_v1');
    await box.delete('$year-$month');
  }

  // Get expenses, optionally filtered by date range
  Future<List<ExpenseModel>> getExpenses([
    int? fromDate,
    int? toDate,
    String? categoryId,
  ]) async {
    final expenses = await _openBox<ExpenseDbModel>('expenses_v2');
    final categories = await _openBox<CategoryDbModel>('categories_v2');

    Iterable<ExpenseDbModel> filtered = expenses.values;

    if (fromDate != null) {
      filtered = filtered.where((expense) => expense.date >= fromDate);
    }

    if (toDate != null) {
      filtered = filtered.where((expense) => expense.date < toDate);
    }

    if (categoryId != null && categoryId.isNotEmpty) {
      filtered = filtered.where((expense) => expense.categoryId == categoryId);
    }

    final filteredExpenses = filtered.toList()
      ..sort((a, b) {
        final dateComparison = b.date - a.date;
        if (dateComparison != 0) return dateComparison;
        final aId = int.tryParse(a.id) ?? 0;
        final bId = int.tryParse(b.id) ?? 0;
        return bId - aId;
      });

    return filteredExpenses.map((exp) {
      final category = categories.get(exp.categoryId);
      final categoryModel = category != null
          ? category.toCategoryModel()
          : CategoryModel(
              id: exp.categoryId,
              parentId: '',
              title: 'دسته نامشخص',
              color: '#000000',
              iconKey: 'ic_other',
            );
      return exp.toExpenseModel(categoryModel);
    }).toList();
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
          if (categoryExpenses.isEmpty) {
            return null;
          }

          final totalPrice = categoryExpenses
              .map((expense) => expense.price)
              .reduce((sum, price) => sum + price);
          return {
            'title': category.title,
            'price': totalPrice,
            'color': category.color,
            'id': category.id,
          };
        })
        .where((element) => element != null)
        .toList();
    expensesByCategory.sort((a, b) {
      final int priceA = a?['price'] as int? ?? 0;
      final int priceB = b?['price'] as int? ?? 0;
      return priceB - priceA;
    });

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
    final expenses = await _openBox<ExpenseDbModel>('expenses_v2');
    final categories = await _openBox<CategoryDbModel>('categories_v2');
    final dollarRates = await _openBox<DollarRateDbModel>('dollar_rates_v1');

    // Sort expenses by date
    final sortedExpenses = expenses.values.toList()
      ..sort((a, b) => b.date - a.date);

    // Create maps for category titles and colors
    final categoriesMap = {
      for (var category in categories.values)
        category.id.toString(): category.title,
    };
    final categoriesColorMap = {
      for (var category in categories.values)
        category.id.toString(): category.color,
    };

    // Prepare a quick lookup for (year,month) -> rate
    double rateForMonth(int year, int month) {
      final key = '$year-$month';
      final r = dollarRates.get(key);
      if (r == null || r.price <= 0) return 0;
      // prices are in Toman; usd = toman / price
      return r.price.toDouble();
    }

    // Group expenses by month and category
    final Map<String, Map<String, dynamic>> reportMap = {};
    for (var expense in sortedExpenses) {
      final jalali = Jalali.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(expense.date),
      );
      final monthKey = '${jalali.year}/${jalali.month}';

      if (!reportMap.containsKey(monthKey)) {
        reportMap[monthKey] = {
          'monthName': monthKey,
          'sumPrice': 0,
          'sumPriceUsd': 0.0,
          'catExpenseList': <dynamic>[],
          '_year': jalali.year,
          '_month': jalali.month,
        };
      }

      final monthData = reportMap[monthKey]!;
      monthData['sumPrice'] += expense.price;
      final rate = rateForMonth(jalali.year, jalali.month);
      if (rate > 0) {
        monthData['sumPriceUsd'] =
            (monthData['sumPriceUsd'] as double) + (expense.price / rate);
      }

      final categoryId = expense.categoryId.toString();
      final catExpenseList = monthData['catExpenseList'] as List<dynamic>;
      final existing = catExpenseList.cast<Map<String, dynamic>?>().firstWhere(
            (e) => e?['id'] == categoryId,
            orElse: () => null,
          );
      if (existing != null) {
        existing['price'] += expense.price;
        existing['transactionCount'] += 1;
        if (rate > 0) {
          existing['usdPrice'] =
              (existing['usdPrice'] as double) + (expense.price / rate);
        }
      } else {
        catExpenseList.add({
          'id': categoryId,
          'title': categoriesMap[categoryId],
          'transactionCount': 1,
          'color': categoriesColorMap[categoryId],
          'price': expense.price,
          'usdPrice': rate > 0 ? (expense.price / rate) : 0.0,
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
      catExpenses.sort(
        (a, b) => (b['price'] as num).toInt() - (a['price'] as num).toInt(),
      );
      // cleanup temp keys
      monthData.remove('_year');
      monthData.remove('_month');
    }

    return reportList;
  }
}
