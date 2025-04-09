import 'package:my_money_v3/core/db/db.dart';
import 'package:my_money_v3/shared/data/models/expense_model.dart';

abstract class FilterExpenseLocalDataSource {
  Future<List<ExpenseModel>> getExpenses([
    int? jalali,
    int? toDate,
    String? categoryId,
  ]);
}

class FilterExpenseLocalDataSourceImpl implements FilterExpenseLocalDataSource {
  final DatabaseHelper databaseHelper;

  FilterExpenseLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<ExpenseModel>> getExpenses([
    int? fromDate,
    int? toDate,
    String? categoryId,
  ]) async {
    final result =
        await databaseHelper.getExpenses(fromDate, toDate, categoryId);
    return result;
  }
}
