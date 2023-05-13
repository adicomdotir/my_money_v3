import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/core/domain/entities/expense.dart';
import 'package:my_money_v3/features/expanse_list/domain/usecases/delete_expense_use_case.dart';
import 'package:my_money_v3/features/expanse_list/domain/usecases/expense_list_use_case.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/domain/usecases/usecase.dart';
import '../../../../core/utils/app_strings.dart';

part 'expense_list_state.dart';

class ExpenseListCubit extends Cubit<ExpenseListState> {
  final ExpenseListUseCase expenseListUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;

  ExpenseListCubit({
    required this.expenseListUseCase,
    required this.deleteExpenseUseCase,
  }) : super(ExpenseListInitial());

  Future<void> getExpenses() async {
    emit(ExpenseListIsLoading());
    Either<Failure, List<Expense>> response =
        await expenseListUseCase(NoParams());
    emit(
      response.fold(
        (failure) => ExpenseListError(msg: _mapFailureToMsg(failure)),
        (expenses) => ExpenseListLoaded(expenses: expenses),
      ),
    );
  }

  Future<void> deleteExpense(String id) async {
    emit(ExpenseListIsLoading());
    Either<Failure, void> response =
        await deleteExpenseUseCase(DeleteExpenseParams(id));
    emit(
      response.fold(
        (failure) => ExpenseListError(msg: _mapFailureToMsg(failure)),
        (success) => ExpenseListDeleteSuccess(),
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
