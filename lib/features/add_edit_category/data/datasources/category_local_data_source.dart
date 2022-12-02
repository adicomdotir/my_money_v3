import 'dart:convert';

import 'package:my_money_v3/core/db/db.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_strings.dart';
import '../models/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<void> addCategory(CategoryModel categoryModel);
  Future<void> updateCategory(CategoryModel categoryModel);
  Future<void> removeCategory(int id);
  Future<CategoryModel> getCategory();
}

class ExpenseLocalDataSourceImpl implements CategoryLocalDataSource {
  final DatabaseHelper databaseHelper;

  ExpenseLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> addCategory(CategoryModel categoryModel) async {
    databaseHelper.addCategory(categoryModel.toJson());
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
  Future<void> updateCategory(CategoryModel categoryModel) {
    // TODO: implement updateCategory
    throw UnimplementedError();
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
