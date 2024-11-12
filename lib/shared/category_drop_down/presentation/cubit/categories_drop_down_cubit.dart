import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../features/category/domain/usecases/category_list_use_case.dart';
import '../../../domain/entities/category.dart';

part 'categories_drop_down_state.dart';

class CategoriesDropDownCubit extends Cubit<CategoriesDropDownState> {
  final CategoryListUseCase categoryListUseCase;

  CategoriesDropDownCubit({
    required this.categoryListUseCase,
  }) : super(CategoriesDropDownInitial());

  Future<void> getCategories() async {
    emit(CategoriesDropDownLoading());
    Either<Failure, List<Category>> response = await categoryListUseCase();
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
