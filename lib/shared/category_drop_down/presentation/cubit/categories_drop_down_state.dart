part of 'categories_drop_down_cubit.dart';

abstract class CategoriesDropDownState extends Equatable {
  const CategoriesDropDownState();

  @override
  List<Object> get props => [];
}

class CategoriesDropDownInitial extends CategoriesDropDownState {}

class CategoriesDropDownLoaded extends CategoriesDropDownState {
  final List<Category> categories;

  const CategoriesDropDownLoaded({required this.categories});
}

class CategoriesDropDownLoading extends CategoriesDropDownState {}

class CategoriesDropDownError extends CategoriesDropDownState {
  final String msg;

  const CategoriesDropDownError({required this.msg});
}
