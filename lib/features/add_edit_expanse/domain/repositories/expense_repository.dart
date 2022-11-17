import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, Expense>> getExpense();
}
