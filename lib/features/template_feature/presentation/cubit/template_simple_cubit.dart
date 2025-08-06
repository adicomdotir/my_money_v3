import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/template_entity.dart';
import '../../domain/repositories/template_repository.dart';

part 'template_simple_state.dart';

/// Cubit pattern example - use for simpler state management
/// This example shows a simpler approach for basic CRUD operations
class TemplateSimpleCubit extends Cubit<TemplateSimpleState> {
  final TemplateRepository repository;

  TemplateSimpleCubit({required this.repository})
      : super(const TemplateSimpleState());

  /// Load all items
  Future<void> loadItems() async {
    emit(state.copyWith(status: TemplateStatus.loading));

    final result = await repository.getTemplateItems();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TemplateStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (items) => emit(
        state.copyWith(
          status: TemplateStatus.loaded,
          items: items,
        ),
      ),
    );
  }

  /// Create a new item
  Future<void> createItem({
    required String title,
    required String description,
    double? amount,
  }) async {
    emit(state.copyWith(status: TemplateStatus.submitting));

    final newItem = TemplateEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      isActive: true,
      amount: amount,
    );

    final result = await repository.createTemplateItem(newItem);

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: TemplateStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (item) async {
        emit(
          state.copyWith(
            status: TemplateStatus.loaded,
            items: [item, ...state.items],
          ),
        );
      },
    );
  }

  /// Delete an item
  Future<void> deleteItem(String id) async {
    final previousItems = [...state.items];

    // Optimistic update
    emit(
      state.copyWith(
        items: state.items.where((item) => item.id != id).toList(),
      ),
    );

    final result = await repository.deleteTemplateItem(id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TemplateStatus.error,
          errorMessage: failure.message,
          items: previousItems, // Restore on failure
        ),
      ),
      (_) => {}, // Success - keep the optimistic update
    );
  }

  /// Toggle item active status
  Future<void> toggleItemStatus(String id) async {
    final item = state.items.firstWhere((item) => item.id == id);
    final updatedItem = item.copyWith(isActive: !item.isActive);

    // Optimistic update
    emit(
      state.copyWith(
        items: state.items
            .map(
              (item) => item.id == id ? updatedItem : item,
            )
            .toList(),
      ),
    );

    final result = await repository.updateTemplateItem(updatedItem);

    result.fold(
      (failure) {
        // Revert on failure
        emit(
          state.copyWith(
            items: state.items
                .map(
                  (i) => i.id == id ? item : i,
                )
                .toList(),
            errorMessage: failure.message,
          ),
        );
      },
      (_) => {}, // Success
    );
  }

  /// Filter items by active status
  void filterByStatus(bool? isActive) {
    emit(state.copyWith(filterIsActive: isActive));
  }

  /// Search items
  void searchItems(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  /// Clear filters
  void clearFilters() {
    emit(
      state.copyWith(
        filterIsActive: null,
        searchQuery: '',
      ),
    );
  }
}
