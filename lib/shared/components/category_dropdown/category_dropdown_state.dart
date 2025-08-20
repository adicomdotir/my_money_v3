import 'package:equatable/equatable.dart';
import 'package:my_money_v3/lib.dart';

abstract class CategoryDropdownState extends Equatable {
  const CategoryDropdownState();

  @override
  List<Object?> get props => [];
}

class CategoryDropdownInitial extends CategoryDropdownState {
  const CategoryDropdownInitial();
}

class CategoryDropdownLoading extends CategoryDropdownState {
  const CategoryDropdownLoading();
}

class CategoryDropdownLoaded extends CategoryDropdownState {
  final List<Category> categories;

  const CategoryDropdownLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class CategoryDropdownError extends CategoryDropdownState {
  final String message;

  const CategoryDropdownError(this.message);

  @override
  List<Object?> get props => [message];
}
