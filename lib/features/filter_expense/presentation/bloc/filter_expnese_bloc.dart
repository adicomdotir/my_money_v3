import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    Jalali fromDate = Jalali.now();
    fromDate = Jalali(fromDate.year, fromDate.month, 1);
    Jalali toDate = Jalali.now();
    toDate = fromDate.addMonths(1);

    emit(FilterExpenseInitial());
    await getFilterExpenseUseCase.call(
      GetFilterExpenseParams(
        fromDate.toDateTime().millisecondsSinceEpoch,
        toDate.toDateTime().millisecondsSinceEpoch,
        event.categoryId,
      ),
    );
  }
}
