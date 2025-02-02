import 'package:my_money_v3/core/db/db.dart';
import 'package:my_money_v3/shared/data/models/expense_model.dart';

abstract class ExpenseLocalDataSource {
  Future<void> addExpense(ExpenseModel expenseModel);
  Future<List<ExpenseModel>> getExpenses([int? jalali, int? toDate]);
  Future<void> deleteExpense(String id);
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final DatabaseHelper databaseHelper;

  ExpenseLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> addExpense(ExpenseModel expenseModel) async {
    return await databaseHelper.addExpanse(
      expenseModel,
    );
  }

  @override
  Future<List<ExpenseModel>> getExpenses([int? fromDate, int? toDate]) async {
    final result = await databaseHelper.getExpenses(fromDate, toDate);
    return result;
  }

  @override
  Future<void> deleteExpense(String id) async {
    return await databaseHelper.deleteExpanse(id);
  }
}
