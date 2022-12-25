import 'package:dartz/dartz.dart';
import 'package:my_money_v3/core/data/models/expense_model.dart';
import '../../../../core/error/failures.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, void>> addExpense(ExpenseModel expenseModel);
}
