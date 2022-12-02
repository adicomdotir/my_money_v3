part of 'add_edit_category_cubit.dart';

abstract class AddEditExpenseState extends Equatable {
  const AddEditExpenseState();

  @override
  List<Object> get props => [];
}

class AddEditExpenseInitial extends AddEditExpenseState {}

class AddEditExpenseIsLoading extends AddEditExpenseState {}

class AddEditExpenseLoaded extends AddEditExpenseState {
  final Expense expense;

  const AddEditExpenseLoaded({required this.expense});

  @override
  List<Object> get props => [expense];
}

class AddEditExpenseError extends AddEditExpenseState {
  final String msg;

  const AddEditExpenseError({required this.msg});

  @override
  List<Object> get props => [msg];
}
