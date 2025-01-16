import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/category/domain/usecases/add_category_use_case.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../shared/domain/entities/category.dart';
import '../../domain/usecases/category_list_use_case.dart';
import '../../domain/usecases/delete_category_use_case.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryListUseCase categoryListUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;
  final AddCategoryUseCase addCategoryUseCase;

  CategoryCubit({
    required this.categoryListUseCase,
    required this.deleteCategoryUseCase,
    required this.addCategoryUseCase,
  }) : super(CategoryInitial());

  Future<void> getCategories() async {
    emit(CategoryIsLoading());
    Either<Failure, List<Category>> response = await categoryListUseCase();
    emit(
      response.fold(
        (failure) => CategoryError(msg: _mapFailureToMsg(failure)),
        (expenses) => CategoryLoaded(categories: expenses),
      ),
    );
  }

  Future<void> deleteCategory(String id) async {
    emit(CategoryIsLoading());
    Either<Failure, bool> response =
        await deleteCategoryUseCase(DeleteCategoryParams(id));
    emit(
      response.fold(
        (failure) => CategoryError(msg: _mapFailureToMsg(failure)),
        (success) => CategoryDeleteSuccess(),
      ),
    );
  }

  Future<void> addCategory(Category category) async {
    emit(CategoryIsLoading());
    Either<Failure, String> response =
        await addCategoryUseCase(CategoryParams(category));
    emit(
      response.fold(
        (failure) => CategoryError(msg: _mapFailureToMsg(failure)),
        (id) => CategoryAddOrEditSuccess(),
      ),
    );
  }

  Future<void> editCategory(Category category) async {
    emit(CategoryIsLoading());
    Either<Failure, dynamic> response =
        await addCategoryUseCase(CategoryParams(category));
    emit(
      response.fold(
        (failure) => CategoryError(msg: _mapFailureToMsg(failure)),
        (id) => CategoryAddOrEditSuccess(),
      ),
    );
  }

  String _mapFailureToMsg(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return AppStrings.serverFailure;
      case CacheFailure _:
        return AppStrings.cacheFailure;
      case DatabaseFailure _:
        return (failure as DatabaseFailure).msg;
      default:
        return AppStrings.unexpectedError;
    }
  }
}
