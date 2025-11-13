import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/shared/domain/entities/expense.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../domain/usecases/get_filter_expense_use_case.dart';

part 'filter_expnese_event.dart';
part 'filter_expnese_state.dart';

class FilterExpneseBloc extends Bloc<FilterExpenseEvent, FilterExpenseState> {
  final GetFilterExpenseUseCase getFilterExpenseUseCase;

  FilterExpneseBloc(this.getFilterExpenseUseCase)
      : super(FilterExpenseInitial()) {
    on<GetFilterExpenseEvent>(_getFilterExpense);
  }

  FutureOr<void> _getFilterExpense(
    GetFilterExpenseEvent event,
    Emitter<FilterExpenseState> emit,
  ) async {
    try {
      emit(FilterExpenseLoading());

      int? fromMillis = event.fromDateMillis;
      int? toMillis = event.toDateMillis;

      if (fromMillis == null && toMillis == null) {
        final now = Jalali.now();
        final start = Jalali(now.year, now.month, 1);
        final end = start.addMonths(1);
        fromMillis = start.toDateTime().millisecondsSinceEpoch;
        toMillis = end.toDateTime().millisecondsSinceEpoch;
      }

      if (fromMillis != null && toMillis != null && toMillis <= fromMillis) {
        toMillis = fromMillis + const Duration(days: 1).inMilliseconds;
      }

      final res = await getFilterExpenseUseCase.call(
        GetFilterExpenseParams(
          fromMillis,
          toMillis,
          event.categoryId,
        ),
      );

      res.fold(
        (failure) => emit(FilterExpenseError('خطا در بارگذاری داده‌ها')),
        (success) => emit(FilterExpenseLoaded(expenses: success)),
      );
    } on Exception catch (e) {
      emit(FilterExpenseError('خطای غیرمنتظره: ${e.toString()}'));
    }
  }
}
