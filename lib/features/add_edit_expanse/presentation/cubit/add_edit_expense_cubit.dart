import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/add_edit_expanse/domain/entities/expense.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_strings.dart';
import '../../domain/usecases/get_expense_use_case.dart';

part 'add_edit_expense_state.dart';

class AddEditExpenseCubit extends Cubit<AddEditExpenseState> {
  final GetExpenseUseCase getExpenseUseCase;

  AddEditExpenseCubit({required this.getExpenseUseCase})
      : super(AddEditExpenseInitial());

  Future<void> getExpense() async {
    emit(AddEditExpenseIsLoading());
    Either<Failure, dynamic> response = await getExpenseUseCase(NoParams());
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
