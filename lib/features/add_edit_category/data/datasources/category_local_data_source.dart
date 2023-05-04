import 'dart:convert';

import 'package:my_money_v3/core/db/db.dart';

import '../../../../core/data/models/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<String> addEditCategory(CategoryModel categoryModel);
  Future<void> removeCategory(int id);
  Future<CategoryModel> getCategory();
  Future<List<CategoryModel>> getCategories();
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
  Future<CategoryModel> getCategory() {
    // TODO: implement getCategory
    throw UnimplementedError();
  }

  @override
  Future<void> removeCategory(int id) {
    // TODO: implement removeCategory
    throw UnimplementedError();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final result = await databaseHelper.getCategories();
    return result.map<CategoryModel>((e) {
      return CategoryModel.fromJson(jsonDecode(jsonEncode(e)));
    }).toList();
  }

  // @override
  // Future<ExpenseModel> getLastExpense() {
  //   final jsonString = sharedPreferences.getString(AppStrings.cachedExpense);
  //   if (jsonString != null) {
  //     final cacheExpense =
  //         Future.value(ExpenseModel.fromJson(json.decode(jsonString)));
  //     return cacheExpense;
  //   } else {
  //     throw CacheException();
  //   }
  // }

  // @override
  // Future<void> cacheExpense(ExpenseModel expense) {
  //   return sharedPreferences.setString(
  //     AppStrings.cachedExpense,
  //     json.encode(expense),
  //   );
  // }
}
