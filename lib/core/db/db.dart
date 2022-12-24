import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_money_v3/features/add_edit_category/presentation/widgets/add_edit_category_content.dart';

class DatabaseHelper {
  // late Box<dynamic> _categories;
  // late Box<dynamic> _expenses;

  DatabaseHelper();

  // Future<void> init() async {
  //   _categories = await Hive.openBox('categories');
  //   _expenses = await Hive.openBox('expenses');
  //   print('init complete');
  // }

  Future<int> addCategory(Map<String, dynamic> categoryJson) async {
    Box<dynamic> categories = await Hive.openBox('categories');
    return await categories.add(categoryJson);
  }

  Future<List<dynamic>> getCategories() async {
    Box<dynamic> categories = await Hive.openBox('categories');
    return categories.values.toList();
  }

  Future<int> addExpanse(Map<String, dynamic> expenseJson) async {
    Box<dynamic> expenses = await Hive.openBox('expenses');
    return await expenses.add(expenseJson);
  }
}
