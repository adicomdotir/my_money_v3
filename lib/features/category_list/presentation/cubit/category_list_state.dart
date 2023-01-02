part of 'category_list_cubit.dart';

abstract class CategoryListState extends Equatable {
  const CategoryListState();

  @override
  List<Object> get props => [];
}

class CategoryListInitial extends CategoryListState {}

class CategoryListIsLoading extends CategoryListState {}

class CategoryListDeleteSuccess extends CategoryListState {}

class CategoryListLoaded extends CategoryListState {
  final List<Category> categories;

  const CategoryListLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoryListError extends CategoryListState {
  final String msg;

  const CategoryListError({required this.msg});

  @override
  List<Object> get props => [msg];
}
