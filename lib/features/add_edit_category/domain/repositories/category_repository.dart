import 'package:dartz/dartz.dart';
import 'package:my_money_v3/features/add_edit_category/data/models/category_model.dart';
import 'package:my_money_v3/features/add_edit_category/domain/entities/category.dart';
import '../../../../core/error/failures.dart';

abstract class CategoryRepository {
  Future<Either<Failure, int>> addCategory(CategoryModel categoryModel);
  Future<Either<Failure, List<Category>>> getCategories();
}
