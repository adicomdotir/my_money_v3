import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/core/domain/usecases/usecase.dart';
import 'package:my_money_v3/core/domain/entities/category.dart';
import 'package:my_money_v3/features/add_edit_category/domain/usecases/get_categories_use_case.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/app_strings.dart';
import '../../domain/usecases/add_category_use_case.dart';

part 'add_edit_category_state.dart';

class AddEditCategoryCubit extends Cubit<AddEditCategoryState> {
  final AddCategoryUseCase addCategoryUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  AddEditCategoryCubit({
    required this.addCategoryUseCase,
    required this.getCategoriesUseCase,
  }) : super(AddEditCategoryInitial());

  Future<void> addCategory(Category category) async {
    emit(AddEditCategoryIsLoading());
    Either<Failure, dynamic> response =
        await addCategoryUseCase(CategoryParams(category));
    emit(
      response.fold(
        (failure) => AddEditCategoryError(msg: _mapFailureToMsg(failure)),
        (id) => AddEditCategorySuccess(id: id),
      ),
    );
  }

  Future<void> getCategories() async {
    emit(AddEditCategoryIsLoading());
    Either<Failure, List<Category>> response =
        await getCategoriesUseCase(NoParams());
    emit(
      response.fold(
        (failure) => AddEditCategoryError(msg: _mapFailureToMsg(failure)),
        (categories) => AddEditCategoryListLoaded(categories: categories),
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
