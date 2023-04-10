part of 'add_edit_category_cubit.dart';

abstract class AddEditCategoryState extends Equatable {
  const AddEditCategoryState();

  @override
  List<Object> get props => [];
}

class AddEditCategoryInitial extends AddEditCategoryState {}

class AddEditCategoryIsLoading extends AddEditCategoryState {}

class AddEditCategoryLoaded extends AddEditCategoryState {
  final Category category;

  const AddEditCategoryLoaded({required this.category});

  @override
  List<Object> get props => [Category];
}

class AddEditCategoryListLoaded extends AddEditCategoryState {
  final List<Category> categories;

  const AddEditCategoryListLoaded({required this.categories});

  @override
  List<Object> get props => [Category];
}

class AddEditCategorySuccess extends AddEditCategoryState {
  final String id;

  const AddEditCategorySuccess({required this.id});

  @override
  List<Object> get props => [Category];
}

class AddEditCategoryError extends AddEditCategoryState {
  final String msg;

  const AddEditCategoryError({required this.msg});

  @override
  List<Object> get props => [msg];
}
