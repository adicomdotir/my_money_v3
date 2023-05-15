import 'package:dartz/dartz.dart';

import '../../../../core/domain/entities/category.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/domain/usecases/usecase.dart';
import '../repositories/category_repository.dart';

class CategoryListUseCase implements UseCase<List<Category>, NoParams> {
  final CategoryRepository categoryRepository;

  CategoryListUseCase({required this.categoryRepository});

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) =>
      categoryRepository.getCategories();
}
