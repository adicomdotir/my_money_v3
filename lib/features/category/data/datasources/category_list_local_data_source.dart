import 'dart:convert';

import 'package:my_money_v3/core/db/db.dart';

import '../../../../core/data/models/category_model.dart';

abstract class CategoryListLocalDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<void> deleteCategory(String id);
}

class CategoryListLocalDataSourceImpl implements CategoryListLocalDataSource {
  final DatabaseHelper databaseHelper;

  CategoryListLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final result = await databaseHelper.getCategories();
    return result.map<CategoryModel>((e) {
      return CategoryModel.fromJson(jsonDecode(jsonEncode(e)));
    }).toList();
  }

  @override
  Future<void> deleteCategory(String id) async {
    return await databaseHelper.deleteCategory(id);
  }
}
