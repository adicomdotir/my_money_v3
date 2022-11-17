import 'package:dartz/dartz.dart';
import 'package:my_money_v3/features/add_edit_expanse/data/datasources/expense_remote_data_source.dart';
import 'package:my_money_v3/features/add_edit_expanse/data/datasources/expnese_local_data_source.dart';
import 'package:my_money_v3/features/add_edit_expanse/domain/entities/expense.dart';
import 'package:my_money_v3/features/add_edit_expanse/domain/repositories/expense_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/netwok_info.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final NetworkInfo networkInfo;
  final ExpenseRemoteDataSource expenseRemoteDataSource;
  final ExpenseLocalDataSource expenseLocalDataSource;

  ExpenseRepositoryImpl({
    required this.networkInfo,
    required this.expenseRemoteDataSource,
    required this.expenseLocalDataSource,
  });

  @override
  Future<Either<Failure, Expense>> getExpense() async {
    // if (await networkInfo.isConnected) {
    try {
      final remoteRandomExpense = await expenseRemoteDataSource.getExpense();
      expenseLocalDataSource.cacheExpense(remoteRandomExpense);
      return Right(remoteRandomExpense);
    } on ServerException {
      return Left(ServerFailure());
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
