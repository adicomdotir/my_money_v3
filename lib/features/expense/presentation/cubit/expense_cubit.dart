import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/core/domain/entities/expense.dart';
import 'package:my_money_v3/features/expense/domain/usecases/add_edit_expense_use_case.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/domain/usecases/usecase.dart';
import '../../../../core/utils/app_strings.dart';
import '../../domain/usecases/delete_expense_use_case.dart';
import '../../domain/usecases/expense_list_use_case.dart';

part 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final ExpenseListUseCase expenseListUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;
  final AddEditExpenseUseCase addEditExpenseUseCase;

  ExpenseCubit({
    required this.expenseListUseCase,
    required this.deleteExpenseUseCase,
    required this.addEditExpenseUseCase,
  }) : super(ExpenseInitial());

  Future<void> getExpenses() async {
    emit(ExpenseIsLoading());
    Either<Failure, List<Expense>> response =
        await expenseListUseCase(NoParams());
    emit(
      response.fold(
        (failure) => ExpenseError(msg: _mapFailureToMsg(failure)),
        (expenses) => ExpenseLoaded(expenses: expenses),
      ),
    );
  }

  Future<void> deleteExpense(String id) async {
    emit(ExpenseIsLoading());
    Either<Failure, void> response =
        await deleteExpenseUseCase(DeleteExpenseParams(id));
    emit(
      response.fold(
        (failure) => ExpenseError(msg: _mapFailureToMsg(failure)),
        (success) => ExpenseDeleteSuccess(),
      ),
    );
  }

  Future<void> addExpense(Expense expense) async {
    emit(ExpenseIsLoading());
    Either<Failure, void> response =
        await addEditExpenseUseCase(ExpenseParams(expense));
    emit(
      response.fold(
        (failure) => ExpenseError(msg: _mapFailureToMsg(failure)),
        (_) => ExpenseAddOrEditSuccess(),
      ),
    );
  }

  Future<void> editExpense(Expense expense) async {
    emit(ExpenseIsLoading());
    Either<Failure, void> response =
        await addEditExpenseUseCase(ExpenseParams(expense));
    emit(
      response.fold(
        (failure) => ExpenseError(msg: _mapFailureToMsg(failure)),
        (_) => ExpenseAddOrEditSuccess(),
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
