import 'package:my_money_v3/features/expanse_list/data/datasources/expnese_list_local_data_source.dart';
import 'package:my_money_v3/features/expanse_list/domain/entities/expense.dart';
import 'package:my_money_v3/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:my_money_v3/features/expanse_list/domain/repositories/expense_list_repository.dart';

class ExpenseListRepositoryImpl implements ExpenseListRepository {
  final ExpenseListLocalDataSource expenseListLocalDataSource;

  ExpenseListRepositoryImpl({
    required this.expenseListLocalDataSource,
  });

  @override
  Future<Either<Failure, List<Expense>>> getExpenses() async {
    final result = await expenseListLocalDataSource.getExpenses();
    return Right(result);
  }
}
