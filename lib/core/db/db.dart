import 'package:hive_flutter/hive_flutter.dart';

class DatabaseHelper {
  late Box<dynamic> _categories;
  late Box<dynamic> _expenses;

  DatabaseHelper() {
    init();
  }

  void init() async {
    _categories = await Hive.openBox('categories');
    _expenses = await Hive.openBox('expenses');
  }

  void addCategory(Map<String, dynamic> categoryJson) async {
    int id = await _categories.add(categoryJson);
    print(id);
  }
}
