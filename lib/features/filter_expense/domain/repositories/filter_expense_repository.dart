import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../shared/domain/entities/expense.dart';

abstract class FilterExpenseRepository {
  Future<Either<Failure, List<Expense>>> getExpenses([
    int? fromDate,
    int? toDate,
    String? categoryId,
  ]);
}
