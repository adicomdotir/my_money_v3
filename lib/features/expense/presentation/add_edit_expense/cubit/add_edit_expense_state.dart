part of 'add_edit_expense_cubit.dart';

abstract class AddExpState extends Equatable {
  const AddExpState();

  @override
  List<Object> get props => [];
}

class AddExpInitial extends AddExpState {}

class AddExpIsLoading extends AddExpState {}

class AddExpError extends AddExpState {
  final String message;

  const AddExpError(this.message);

  @override
  List<Object> get props => [message];
}

class AddExpSuccess extends AddExpState {}
