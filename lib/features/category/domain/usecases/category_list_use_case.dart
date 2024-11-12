import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/entities/category.dart';
import '../repositories/category_repository.dart';

class CategoryListUseCase implements UseCaseWithoutParam<List<Category>> {
  final CategoryRepository categoryRepository;

  CategoryListUseCase({required this.categoryRepository});

  @override
  Future<Either<Failure, List<Category>>> call() =>
      categoryRepository.getCategories();
}
