import 'package:dartz/dartz.dart';
import 'package:my_money_v3/shared/data/models/category_model.dart';
import 'package:my_money_v3/shared/domain/entities/category.dart';
import 'package:my_money_v3/core/error/exceptions.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource categoryLocalDataSource;

  CategoryRepositoryImpl({
    required this.categoryLocalDataSource,
  });

  @override
  Future<Either<Failure, String>> addEditCategory(
    CategoryModel categoryModel,
  ) async {
    var result = await categoryLocalDataSource.addEditCategory(categoryModel);
    return Right(result);
  }

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    final result = await categoryLocalDataSource.getCategories();
    return Right(result);
  }

  @override
  Future<Either<Failure, bool>> deleteCategory(String id) async {
    try {
      final result = await categoryLocalDataSource.deleteCategory(id);
      return Right(result);
    } on DatabaseException catch (ex) {
      return Left(DatabaseFailure(ex.message ?? ''));
    }
  }
}
