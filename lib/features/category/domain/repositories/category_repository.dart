import 'package:dartz/dartz.dart';
import 'package:my_money_v3/core/data/models/category_model.dart';
import 'package:my_money_v3/core/domain/entities/category.dart';
import '../../../../core/error/failures.dart';

abstract class CategoryRepository {
  Future<Either<Failure, String>> addEditCategory(CategoryModel categoryModel);
  Future<Either<Failure, List<Category>>> getCategories();
}
