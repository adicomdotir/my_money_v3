import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/domain/entities/expense.dart';

abstract class ExpenseListRepository {
  Future<Either<Failure, List<Expense>>> getExpenses();
}
