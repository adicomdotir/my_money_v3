part of 'expense_list_cubit.dart';

abstract class ExpenseListState extends Equatable {
  const ExpenseListState();

  @override
  List<Object> get props => [];
}

class ExpenseListInitial extends ExpenseListState {}

class ExpenseListIsLoading extends ExpenseListState {}

class ExpenseListDeleteSuccess extends ExpenseListState {}

class ExpenseListLoaded extends ExpenseListState {
  final List<Expense> expenses;

  const ExpenseListLoaded({required this.expenses});

  @override
  List<Object> get props => [expenses];
}

class ExpenseListError extends ExpenseListState {
  final String msg;

  const ExpenseListError({required this.msg});

  @override
  List<Object> get props => [msg];
}
