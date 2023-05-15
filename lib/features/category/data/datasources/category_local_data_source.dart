import 'dart:convert';

import 'package:my_money_v3/core/db/db.dart';

import '../../../../core/data/models/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<String> addEditCategory(CategoryModel categoryModel);
  Future<List<CategoryModel>> getCategories();
  Future<void> deleteCategory(String id);
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final DatabaseHelper databaseHelper;

  CategoryLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> addEditCategory(CategoryModel categoryModel) async {
    return await databaseHelper.addCategory(
      categoryModel.toJson(),
      categoryModel.id,
    );
  }

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
