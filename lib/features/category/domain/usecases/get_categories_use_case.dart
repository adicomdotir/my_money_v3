import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/entities/category.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase implements UseCase<List<Category>, NoParams> {
  final CategoryRepository categoryRepository;

  GetCategoriesUseCase({required this.categoryRepository});

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) =>
      categoryRepository.getCategories();
}
