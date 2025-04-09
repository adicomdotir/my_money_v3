part of 'filter_expnese_bloc.dart';

sealed class FilterExpenseEvent extends Equatable {
  const FilterExpenseEvent();

  @override
  List<Object> get props => [];
}

class GetFilterExpenseEvent extends FilterExpenseEvent {
  final String categoryId;

  const GetFilterExpenseEvent(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
