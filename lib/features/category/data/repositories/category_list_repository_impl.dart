import 'package:my_money_v3/core/error/failures.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/domain/entities/category.dart';
import '../../domain/repositories/category_list_repository.dart';
import '../datasources/category_list_local_data_source.dart';

class CategoryListRepositoryImpl implements CategoryListRepository {
  final CategoryListLocalDataSource categoryListLocalDataSource;

  CategoryListRepositoryImpl({
    required this.categoryListLocalDataSource,
  });

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    final result = await categoryListLocalDataSource.getCategories();
    return Right(result);
  }

  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    final result = await categoryListLocalDataSource.deleteCategory(id);
    return Right(result);
  }
}
