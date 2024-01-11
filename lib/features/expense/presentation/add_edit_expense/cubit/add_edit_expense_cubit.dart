import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/core/domain/entities/expense.dart';
import 'package:my_money_v3/core/error/failures.dart';
import 'package:my_money_v3/core/utils/app_strings.dart';
import 'package:my_money_v3/features/expense/domain/usecases/add_edit_expense_use_case.dart';

part 'add_edit_expense_state.dart';

class AddEditExpenseCubit extends Cubit<AddExpState> {
  final AddEditExpenseUseCase addEditExpenseUseCase;

  AddEditExpenseCubit({
    required this.addEditExpenseUseCase,
  }) : super(AddExpInitial());

  Future<void> addExpense(Expense expense) async {
    emit(AddExpIsLoading());
    Either<Failure, void> response =
        await addEditExpenseUseCase(ExpenseParams(expense));
    emit(
      response.fold(
        (failure) => AddExpError(
          _mapFailureToMsg(failure),
        ),
        (_) => AddExpSuccess(),
      ),
    );
  }

  Future<void> editExpense(Expense expense) async {
    emit(AddExpIsLoading());
    Either<Failure, void> response =
        await addEditExpenseUseCase(ExpenseParams(expense));
    emit(
      response.fold(
        (failure) => AddExpError(
          _mapFailureToMsg(failure),
        ),
        (_) => AddExpSuccess(),
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
