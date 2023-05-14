part of 'expense_cubit.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseIsLoading extends ExpenseState {}

class ExpenseDeleteSuccess extends ExpenseState {}

class ExpenseAddOrEditSuccess extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expenses;

  const ExpenseLoaded({required this.expenses});

  @override
  List<Object> get props => [expenses];
}

class ExpenseError extends ExpenseState {
  final String msg;

  const ExpenseError({required this.msg});

  @override
  List<Object> get props => [msg];
}

class AddEditExpenseLoaded extends ExpenseState {
  final Expense expense;

  const AddEditExpenseLoaded({required this.expense});

  @override
  List<Object> get props => [expense];
}
