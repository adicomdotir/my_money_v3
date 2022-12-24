import 'package:dartz/dartz.dart';
import 'package:my_money_v3/features/add_edit_expanse/data/models/expense_model.dart';
import '../../../../core/error/failures.dart';
import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, int>> addExpense(ExpenseModel expenseModel);
}
