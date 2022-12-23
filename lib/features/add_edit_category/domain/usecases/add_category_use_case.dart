import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:my_money_v3/features/add_edit_category/data/models/category_model.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class AddCategoryUseCase implements UseCase<int, CategoryParams> {
  final CategoryRepository categoryRepository;

  AddCategoryUseCase({required this.categoryRepository});

  @override
  Future<Either<Failure, int>> call(CategoryParams params) =>
      categoryRepository.addCategory(
        CategoryModel(
          id: params.category.id,
          parentId: params.category.parentId,
          title: params.category.title,
          color: params.category.color,
        ),
      );
}

class CategoryParams extends Equatable {
  final Category category;

  const CategoryParams(this.category);

  @override
  List<Object?> get props => [category];
}
