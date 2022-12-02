import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/add_edit_expanse/domain/entities/expense.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_strings.dart';
import '../../domain/usecases/add_category_use_case.dart';

part 'add_edit_category_state.dart';

class AddEditCategoryCubit extends Cubit<AddEditExpenseState> {
  final AddCategoryUseCase addCategoryUseCase;

  AddEditCategoryCubit({required this.addCategoryUseCase})
      : super(AddEditExpenseInitial());

  Future<void> addCategory(String title, String color) async {
    emit(AddEditExpenseIsLoading());
    Either<Failure, dynamic> response =
        await addCategoryUseCase(CategoryParams(title, color));
    emit(
      response.fold(
        (failure) => AddEditExpenseError(msg: _mapFailureToMsg(failure)),
        (quote) => AddEditExpenseLoaded(expense: quote),
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
