import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_strings.dart';
import '../models/expense_model.dart';

abstract class ExpenseLocalDataSource {
  Future<ExpenseModel> getLastExpense();
  Future<void> cacheExpense(ExpenseModel expense);
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final SharedPreferences sharedPreferences;

  ExpenseLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ExpenseModel> getLastExpense() {
    final jsonString = sharedPreferences.getString(AppStrings.cachedExpense);
    if (jsonString != null) {
      final cacheExpense =
          Future.value(ExpenseModel.fromJson(json.decode(jsonString)));
      return cacheExpense;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheExpense(ExpenseModel expense) {
    return sharedPreferences.setString(
      AppStrings.cachedExpense,
      json.encode(expense),
    );
  }
}
