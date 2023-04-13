import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_money_v3/core/data/models/expense_model.dart';
import 'package:my_money_v3/features/add_edit_category/presentation/widgets/add_edit_category_content.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class DatabaseHelper {
  // late Box<dynamic> _categories;
  // late Box<dynamic> _expenses;

  DatabaseHelper();

  // Future<void> init() async {
  //   _categories = await Hive.openBox('categories');
  //   _expenses = await Hive.openBox('expenses');
  //   print('init complete');
  // }

  Future<String> addCategory(
    Map<String, dynamic> categoryJson,
    String id,
  ) async {
    Box<dynamic> categories = await Hive.openBox('categories');
    await categories.put(id, categoryJson);
    return id;
  }

  Future<List<dynamic>> getCategories() async {
    Box<dynamic> categories = await Hive.openBox('categories');
    return categories.values.toList();
  }

  Future<void> addExpanse(Map<String, dynamic> expenseJson, String id) async {
    Box<dynamic> expenses = await Hive.openBox('expenses');
    return await expenses.put(id, expenseJson);
  }

  Future<void> deleteExpanse(String id) async {
    Box<dynamic> expenses = await Hive.openBox('expenses');
    return await expenses.delete(id);
  }

  Future<void> deleteCategory(String id) async {
    Box<dynamic> categories = await Hive.openBox('categories');
    return await categories.delete(id);
  }

  Future<List<dynamic>> getExpenses() async {
    Box<dynamic> categories = await Hive.openBox('categories');
    Box<dynamic> expenses = await Hive.openBox('expenses');
    for (var element in expenses.values) {
      final map = categories.get(element['categoryId']);
      element['category'] = map;
    }
    final result = expenses.values.toList();
    result.sort((a, b) {
      return b['date'] - a['date'];
    });
    return result;
  }

  Future<dynamic> getHomeInfo() async {
    Jalali jalali = Jalali.now();
    jalali = jalali.copy(day: 1, hour: 0, minute: 0, second: 0);
    int date = jalali.toDateTime().millisecondsSinceEpoch;
    Box<dynamic> categories = await Hive.openBox('categories');
    Box<dynamic> expenses = await Hive.openBox('expenses');
    for (var element in expenses.values) {
      final map = categories.get(element['categoryId']);
      element['category'] = map;
    }
    List<dynamic> list = [];
    final result = expenses.values.where((element) => element['date'] >= date);
    for (var category in categories.values) {
      final resultByCategory =
          result.where((item) => item['categoryId'] == category['id']);
      if (resultByCategory.isNotEmpty) {
        final price = resultByCategory
            .map((item) => item['price'])
            .reduce((sum, price) => sum + price);
        list.add({
          'title': category['title'],
          'price': price,
          'color': category['color'],
        });
      }
    }
    return {
      'expenseByCategory': list,
    };
  }
}
