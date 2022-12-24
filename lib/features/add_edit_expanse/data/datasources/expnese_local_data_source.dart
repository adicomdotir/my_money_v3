import 'dart:convert';

import 'package:my_money_v3/core/db/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_strings.dart';
import '../models/expense_model.dart';

abstract class ExpenseLocalDataSource {
  Future<int> addExpense(ExpenseModel expenseModel);
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final DatabaseHelper databaseHelper;

  ExpenseLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<int> addExpense(ExpenseModel expenseModel) async {
    return await databaseHelper.addExpanse(expenseModel.toJson());
  }
}
