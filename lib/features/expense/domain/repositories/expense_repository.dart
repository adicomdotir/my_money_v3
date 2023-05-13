import 'package:dartz/dartz.dart';
import '../../../../core/data/models/expense_model.dart';
import '../../../../core/domain/entities/expense.dart';
import '../../../../core/error/failures.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, void>> addExpense(ExpenseModel expenseModel);
  Future<Either<Failure, List<Expense>>> getExpenses();
  Future<Either<Failure, void>> deleteExpense(String id);
}
