import 'dart:convert';

import 'package:my_money_v3/core/db/db.dart';
import '../models/expense_model.dart';

abstract class ExpenseListLocalDataSource {
  Future<List<ExpenseModel>> getExpenses();
}

class ExpenseListLocalDataSourceImpl implements ExpenseListLocalDataSource {
  final DatabaseHelper databaseHelper;

  ExpenseListLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    final result = await databaseHelper.getExpenses();
    return result.map<ExpenseModel>((e) {
      return ExpenseModel.fromJson(jsonDecode(jsonEncode(e)));
    }).toList();
  }
}
