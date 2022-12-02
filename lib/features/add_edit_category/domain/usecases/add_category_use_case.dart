import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:my_money_v3/features/add_edit_category/data/models/category_model.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/category_repository.dart';

class AddCategoryUseCase implements UseCase<int, CategoryParams> {
  final CategoryRepository categoryRepository;

  AddCategoryUseCase({required this.categoryRepository});

  @override
  Future<Either<Failure, int>> call(CategoryParams params) =>
      categoryRepository.addCategory(
        CategoryModel(
          id: 0,
          title: params.title,
          color: params.color,
        ),
      );
}

class CategoryParams extends Equatable {
  final String title;
  final String color;

  const CategoryParams(
    this.title,
    this.color,
  );

  @override
  List<Object?> get props => [title, color];
}
