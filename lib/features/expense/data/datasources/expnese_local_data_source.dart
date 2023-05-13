import 'dart:convert';

import 'package:my_money_v3/core/data/models/expense_model.dart';
import 'package:my_money_v3/core/db/db.dart';

abstract class ExpenseLocalDataSource {
  Future<void> addExpense(ExpenseModel expenseModel);
  Future<List<ExpenseModel>> getExpenses();
  Future<void> deleteExpense(String id);
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final DatabaseHelper databaseHelper;

  ExpenseLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> addExpense(ExpenseModel expenseModel) async {
    return await databaseHelper.addExpanse(
      expenseModel.toJson(),
      expenseModel.id,
    );
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    final result = await databaseHelper.getExpenses();
    return result.map<ExpenseModel>((e) {
      return ExpenseModel.fromJson(jsonDecode(jsonEncode(e)));
    }).toList();
  }

  @override
  Future<void> deleteExpense(String id) async {
    return await databaseHelper.deleteExpanse(id);
  }
}
