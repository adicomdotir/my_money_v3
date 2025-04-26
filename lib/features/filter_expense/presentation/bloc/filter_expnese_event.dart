part of 'filter_expnese_bloc.dart';

sealed class FilterExpenseEvent extends Equatable {
  const FilterExpenseEvent();

  @override
  List<Object> get props => [];
}

class GetFilterExpenseEvent extends FilterExpenseEvent {
  final String categoryId;
  final String? fromDate;

  const GetFilterExpenseEvent(this.categoryId, this.fromDate);

  @override
  List<Object> get props => [categoryId];
}
