import 'package:dartz/dartz.dart';
import 'package:my_money_v3/features/add_edit_category/data/datasources/category_local_data_source.dart';
import 'package:my_money_v3/features/add_edit_category/data/models/category_model.dart';
import 'package:my_money_v3/features/add_edit_category/domain/entities/category.dart';
import 'package:my_money_v3/features/add_edit_category/domain/repositories/category_repository.dart';
import 'package:my_money_v3/features/add_edit_expanse/data/datasources/expense_remote_data_source.dart';
import 'package:my_money_v3/features/add_edit_expanse/data/datasources/expnese_local_data_source.dart';
import 'package:my_money_v3/features/add_edit_expanse/domain/entities/expense.dart';
import 'package:my_money_v3/features/add_edit_expanse/domain/repositories/expense_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/netwok_info.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource categoryLocalDataSource;

  CategoryRepositoryImpl({
    required this.categoryLocalDataSource,
  });

  @override
  Future<Either<Failure, int>> addCategory(CategoryModel categoryModel) async {
    int result = await categoryLocalDataSource.addCategory(categoryModel);
    return Right(result);
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    final result = await categoryLocalDataSource.getCategories();
    return Right(result);
  }

  // @override
  // Future<Either<Failure, Expense>> getExpense() async {
  //   // if (await networkInfo.isConnected) {
  //   try {
  //     final remoteRandomExpense = await expenseRemoteDataSource.getExpense();
  //     expenseLocalDataSource.cacheExpense(remoteRandomExpense);
  //     return Right(remoteRandomExpense);
  //   } on ServerException {
  //     return Left(ServerFailure());
  //   }
  // }
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
