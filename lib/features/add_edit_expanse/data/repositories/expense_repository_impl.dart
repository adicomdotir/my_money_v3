import 'package:dartz/dartz.dart';
import 'package:my_money_v3/core/data/models/expense_model.dart';
import 'package:my_money_v3/features/add_edit_expanse/data/datasources/expense_remote_data_source.dart';
import 'package:my_money_v3/features/add_edit_expanse/data/datasources/expnese_local_data_source.dart';
import 'package:my_money_v3/features/add_edit_expanse/domain/repositories/expense_repository.dart';

import '../../../../core/error/failures.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource expenseRemoteDataSource;
  final ExpenseLocalDataSource expenseLocalDataSource;

  ExpenseRepositoryImpl({
    required this.expenseRemoteDataSource,
    required this.expenseLocalDataSource,
  });

  @override
  Future<Either<Failure, void>> addExpense(ExpenseModel expenseModel) async {
    try {
      var result = await expenseLocalDataSource.addExpense(expenseModel);
      return Right(result);
    } on Exception {
      return Left(DatabaseFailure());
    }
  }
  //   else {
  //     try {
  //       final cacheRandomExpense =
  //           await randomExpenseLocalDataSource.getLastRandomExpense();
  //       return Right(cacheRandomExpense);
  //     } on CacheException {
  //       return Left(CacheFailure());
  //     }
  //   }
  // }
}
