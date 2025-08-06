import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/domain/entities/expense.dart';
import '../../../../expense/domain/usecases/add_edit_expense_use_case.dart';

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
      case ServerFailure _:
        return AppConstants.serverFailure;
      case CacheFailure _:
        return AppConstants.cacheFailure;
      default:
        return AppConstants.unexpectedError;
    }
  }
}
