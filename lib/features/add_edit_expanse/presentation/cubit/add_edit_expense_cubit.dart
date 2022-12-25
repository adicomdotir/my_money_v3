import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/core/domain/entities/expense.dart';
import 'package:my_money_v3/core/domain/entities/category.dart';
import 'package:my_money_v3/features/add_edit_category/domain/usecases/get_categories_use_case.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/domain/usecases/usecase.dart';
import '../../../../core/utils/app_strings.dart';
import '../../domain/usecases/add_edit_expense_use_case.dart';

part 'add_edit_expense_state.dart';

class AddEditExpenseCubit extends Cubit<AddEditExpenseState> {
  final AddEditExpenseUseCase addEditExpenseUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  AddEditExpenseCubit({
    required this.addEditExpenseUseCase,
    required this.getCategoriesUseCase,
  }) : super(AddEditExpenseInitial());

  Future<void> addExpense(Expense expense) async {
    emit(AddEditExpenseIsLoading());
    Either<Failure, dynamic> response =
        await addEditExpenseUseCase(ExpenseParams(expense));
    emit(
      response.fold(
        (failure) => AddEditExpenseError(msg: _mapFailureToMsg(failure)),
        (id) => AddEditExpenseSuccess(id: id),
      ),
    );
  }

  Future<void> getCategories() async {
    emit(AddEditExpenseIsLoading());
    Either<Failure, List<Category>> response =
        await getCategoriesUseCase(NoParams());
    emit(
      response.fold(
        (failure) => AddEditExpenseError(msg: _mapFailureToMsg(failure)),
        (categories) => AddEditExpenseLoadCategories(categories: categories),
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
