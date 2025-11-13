part of 'filter_expnese_bloc.dart';

sealed class FilterExpenseEvent extends Equatable {
  const FilterExpenseEvent();

  @override
  List<Object> get props => [];
}

class GetFilterExpenseEvent extends FilterExpenseEvent {
  final String categoryId;
  final int? fromDateMillis;
  final int? toDateMillis;

  const GetFilterExpenseEvent({
    required this.categoryId,
    this.fromDateMillis,
    this.toDateMillis,
  });

  @override
  List<Object> get props =>
      [categoryId, fromDateMillis ?? 0, toDateMillis ?? 0];
}
