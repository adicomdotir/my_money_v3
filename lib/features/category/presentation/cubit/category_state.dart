part of 'category_cubit.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryIsLoading extends CategoryState {}

class CategoryDeleteSuccess extends CategoryState {}

class CategoryAddOrEditSuccess extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;

  const CategoryLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoryError extends CategoryState {
  final String msg;

  const CategoryError({required this.msg});

  @override
  List<Object> get props => [msg];
}
