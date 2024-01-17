import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/category.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../features/category/domain/usecases/category_list_use_case.dart';

part 'categories_drop_down_state.dart';

class CategoriesDropDownCubit extends Cubit<CategoriesDropDownState> {
  final CategoryListUseCase categoryListUseCase;

  CategoriesDropDownCubit({
    required this.categoryListUseCase,
  }) : super(CategoriesDropDownInitial());

  Future<void> getCategories() async {
    emit(CategoriesDropDownLoading());
    Either<Failure, List<Category>> response =
        await categoryListUseCase(NoParams());
    emit(
      response.fold(
        (failure) => CategoriesDropDownError(msg: _mapFailureToMsg(failure)),
        (categories) => CategoriesDropDownLoaded(categories: categories),
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
