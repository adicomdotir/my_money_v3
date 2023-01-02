import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/entities/category.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/domain/usecases/usecase.dart';
import '../../../../core/utils/app_strings.dart';
import '../../domain/usecases/category_list_use_case.dart';
import '../../domain/usecases/delete_category_use_case.dart';

part 'category_list_state.dart';

class CategoryListCubit extends Cubit<CategoryListState> {
  final CategoryListUseCase categoryListUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;

  CategoryListCubit({
    required this.categoryListUseCase,
    required this.deleteCategoryUseCase,
  }) : super(CategoryListInitial());

  Future<void> getCategories() async {
    emit(CategoryListIsLoading());
    Either<Failure, List<Category>> response =
        await categoryListUseCase(NoParams());
    emit(
      response.fold(
        (failure) => CategoryListError(msg: _mapFailureToMsg(failure)),
        (expenses) => CategoryListLoaded(categories: expenses),
      ),
    );
  }

  Future<void> deleteCategory(String id) async {
    emit(CategoryListIsLoading());
    Either<Failure, void> response =
        await deleteCategoryUseCase(DeleteCategoryParams(id));
    emit(
      response.fold(
        (failure) => CategoryListError(msg: _mapFailureToMsg(failure)),
        (success) => CategoryListDeleteSuccess(),
      ),
    );
  }

  String _mapFailureToMsg(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return AppStrings.serverFailure;
      case CacheFailure:
        return AppStrings.cacheFailure;
      default:
        return AppStrings.unexpectedError;
    }
  }
}
