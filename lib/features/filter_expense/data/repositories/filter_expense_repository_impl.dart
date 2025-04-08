import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../shared/domain/entities/expense.dart';
import '../../domain/repositories/filter_expense_repository.dart';
import '../datasources/filter_expnese_local_data_source.dart';

class FilterExpenseRepositoryImpl implements FilterExpenseRepository {
  final FilterExpenseLocalDataSource dataSource;

  FilterExpenseRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<Failure, List<Expense>>> getExpenses([
    int? fromDate,
    int? toDate,
    String? categoryId,
  ]) async {
    final result = await dataSource.getExpenses(fromDate, toDate);
    return Right(result);
  }
}
