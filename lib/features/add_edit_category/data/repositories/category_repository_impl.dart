import 'package:dartz/dartz.dart';
import 'package:my_money_v3/features/add_edit_category/data/datasources/category_local_data_source.dart';
import 'package:my_money_v3/core/data/models/category_model.dart';
import 'package:my_money_v3/core/domain/entities/category.dart';
import 'package:my_money_v3/features/add_edit_category/domain/repositories/category_repository.dart';

import '../../../../core/error/failures.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource categoryLocalDataSource;

  CategoryRepositoryImpl({
    required this.categoryLocalDataSource,
  });

  @override
  Future<Either<Failure, void>> addCategory(CategoryModel categoryModel) async {
    var result = await categoryLocalDataSource.addCategory(categoryModel);
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
