part of 'filter_expnese_bloc.dart';

sealed class FilterExpenseState extends Equatable {
  const FilterExpenseState();

  @override
  List<Object> get props => [];
}

final class FilterExpenseInitial extends FilterExpenseState {}

final class FilterExpenseLoaded extends FilterExpenseState {
  final List<Expense> expenses;

  const FilterExpenseLoaded({
    required this.expenses,
  });
  @override
  List<Object> get props => [expenses];
}
