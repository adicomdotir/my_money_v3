import 'package:my_money_v3/core/data/models/expense_model.dart';
import 'package:my_money_v3/core/db/db.dart';

abstract class ExpenseLocalDataSource {
  Future<void> addExpense(ExpenseModel expenseModel);
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
}
