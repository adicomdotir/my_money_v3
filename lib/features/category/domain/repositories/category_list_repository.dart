import 'package:dartz/dartz.dart';
import '../../../../core/domain/entities/category.dart';
import '../../../../core/error/failures.dart';

abstract class CategoryListRepository {
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, void>> deleteCategory(String id);
}
