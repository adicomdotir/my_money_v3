import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/domain/entities/expense.dart';
import '../../../../expense/domain/usecases/delete_expense_use_case.dart';
import '../../../../expense/domain/usecases/expense_list_use_case.dart';

part 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final ExpenseListUseCase expenseListUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;

  ExpenseCubit({
    required this.expenseListUseCase,
    required this.deleteExpenseUseCase,
  }) : super(ExpenseState(calenderFilterType: 0, fromDate: Jalali.now()));

  Future<void> getExpenses() async {
    emit(state.copyWith(loading: true));
    Either<Failure, List<Expense>> response = await expenseListUseCase(
      state.fromDate == null
          ? GetExpensesParams()
          : GetExpensesParams(
              state.fromDate
                  ?.copy(hour: 0, minute: 0, second: 0, millisecond: 0)
                  .toDateTime()
                  .millisecondsSinceEpoch,
              state.toDate
                  ?.copy(hour: 0, minute: 0, second: 0, millisecond: 0)
                  .toDateTime()
                  .millisecondsSinceEpoch,
            ),
    );
    emit(
      response.fold(
        (failure) => state.copyWith(
          error: _mapFailureToMsg(failure),
          loading: false,
        ),
        (expenses) => state.copyWith(
          expenses: expenses,
          loading: false,
        ),
      ),
    );
  }

  Future<void> deleteExpense(String id) async {
    emit(state.copyWith(loading: true));
    Either<Failure, void> response =
        await deleteExpenseUseCase(DeleteExpenseParams(id));
    emit(
      response.fold(
        (failure) => state.copyWith(
          error: _mapFailureToMsg(failure),
          loading: false,
        ),
        (success) => state.copyWith(loading: false),
      ),
    );
    getExpenses();
  }

  Future<void> changeCalenderFilterType(int value) async {
    late Jalali fromDate, toDate;
    if (value == 0) {
      fromDate = Jalali.now();
      toDate = fromDate.addDays(1);
    } else if (value == 1) {
      fromDate = Jalali.now().add(days: (1 - Jalali.now().weekDay));
      toDate = fromDate.addDays(7);
    } else if (value == 2) {
      fromDate = Jalali.now();
      fromDate = Jalali(fromDate.year, fromDate.month, 1);
      toDate = fromDate.addMonths(1);
    }
    emit(
      state.copyWith(
        calenderFilterType: value,
        fromDate: fromDate,
        toDate: toDate,
      ),
    );
    getExpenses();
  }

  void changeFromDate(Jalali newFromDate) {
    if (state.calenderFilterType == 0) {
      emit(
        state.copyWith(
          fromDate: newFromDate,
          toDate: newFromDate.addDays(1),
        ),
      );
    } else if (state.calenderFilterType == 1) {
      emit(
        state.copyWith(
          fromDate: newFromDate,
          toDate: newFromDate.addDays(7),
        ),
      );
    } else if (state.calenderFilterType == 2) {
      emit(
        state.copyWith(
          fromDate: newFromDate,
          toDate: newFromDate.addMonths(1),
        ),
      );
    }
    getExpenses();
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
