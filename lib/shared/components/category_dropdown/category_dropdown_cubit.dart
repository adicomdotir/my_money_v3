import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failures.dart';
import '../../../features/category/domain/usecases/category_list_use_case.dart';
import '../../domain/entities/category.dart';
import 'category_dropdown_state.dart';

/// Cubit for managing category dropdown state and operations
class CategoryDropdownCubit extends Cubit<CategoryDropdownState> {
  CategoryDropdownCubit({required this.categoryListUseCase})
      : super(const CategoryDropdownInitial());

  final CategoryListUseCase categoryListUseCase;

  /// Fetches categories for the dropdown
  /// This is a placeholder implementation - in a real app,
  /// you would inject a repository or service
  Future<void> getCategories() async {
    emit(const CategoryDropdownLoading());

    try {
      Either<Failure, List<Category>> response =
          await categoryListUseCase.call();
      response.fold(
        (failure) => emit(CategoryDropdownError(failure.message)),
        (categories) => emit(CategoryDropdownLoaded(categories)),
      );
    } on Exception catch (e) {
      emit(CategoryDropdownError('خطا در بارگذاری دسته‌ها: $e'));
    }
  }
}
