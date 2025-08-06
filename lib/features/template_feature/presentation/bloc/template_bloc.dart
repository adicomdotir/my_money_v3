import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../domain/entities/template_entity.dart';
import '../../domain/usecases/create_template_item_usecase.dart';
import '../../domain/usecases/get_template_items_usecase.dart';

part 'template_event.dart';
part 'template_state.dart';

/// BLoC pattern example - use for complex state management with events
class TemplateBloc extends Bloc<TemplateEvent, TemplateState> {
  final GetTemplateItemsUseCase getTemplateItemsUseCase;
  final CreateTemplateItemUseCase createTemplateItemUseCase;

  // Debounce timer for search
  Timer? _searchDebounce;

  TemplateBloc({
    required this.getTemplateItemsUseCase,
    required this.createTemplateItemUseCase,
  }) : super(const TemplateInitial()) {
    on<LoadTemplateItemsEvent>(_onLoadTemplateItems);
    on<CreateTemplateItemEvent>(_onCreateTemplateItem);
    on<SearchTemplateItemsEvent>(_onSearchTemplateItems);
    on<FilterTemplateItemsEvent>(_onFilterTemplateItems);
    on<RefreshTemplateItemsEvent>(_onRefreshTemplateItems);
  }

  Future<void> _onLoadTemplateItems(
    LoadTemplateItemsEvent event,
    Emitter<TemplateState> emit,
  ) async {
    emit(const TemplateLoading());

    final result = await getTemplateItemsUseCase(
      GetTemplateItemsParams(
        fromDate: event.fromDate,
        toDate: event.toDate,
        isActive: event.isActive,
      ),
    );

    result.fold(
      (failure) => emit(TemplateError(message: _mapFailureToMessage(failure))),
      (items) => emit(TemplateLoaded(
        items: items,
        filteredItems: items,
        isFiltered: false,
      ),),
    );
  }

  Future<void> _onCreateTemplateItem(
    CreateTemplateItemEvent event,
    Emitter<TemplateState> emit,
  ) async {
    final currentState = state;
    if (currentState is TemplateLoaded) {
      emit(currentState.copyWith(isCreating: true));

      final result = await createTemplateItemUseCase(
        CreateTemplateItemParams(
          title: event.title,
          description: event.description,
          isActive: event.isActive,
          amount: event.amount,
          metadata: event.metadata,
        ),
      );

      await result.fold(
        (failure) async {
          emit(currentState.copyWith(
            isCreating: false,
            error: _mapFailureToMessage(failure),
          ),);
        },
        (newItem) async {
          // Add new item to the list
          final updatedItems = [newItem, ...currentState.items];
          emit(TemplateLoaded(
            items: updatedItems,
            filteredItems: currentState.isFiltered
                ? _applyCurrentFilters(updatedItems, currentState)
                : updatedItems,
            isFiltered: currentState.isFiltered,
            lastCreatedItem: newItem,
          ),);
        },
      );
    }
  }

  Future<void> _onSearchTemplateItems(
    SearchTemplateItemsEvent event,
    Emitter<TemplateState> emit,
  ) async {
    // Cancel previous timer
    _searchDebounce?.cancel();

    if (state is TemplateLoaded) {
      final currentState = state as TemplateLoaded;

      // Debounce search
      _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
        if (event.query.isEmpty) {
          emit(currentState.copyWith(
            filteredItems: currentState.items,
            isFiltered: false,
          ),);
          return;
        }

        final result = await getTemplateItemsUseCase(
          GetTemplateItemsParams(searchQuery: event.query),
        );

        result.fold(
          (failure) => emit(TemplateError(message: _mapFailureToMessage(failure))),
          (items) => emit(currentState.copyWith(
            filteredItems: items,
            isFiltered: true,
            currentSearchQuery: event.query,
          ),),
        );
      });
    }
  }

  Future<void> _onFilterTemplateItems(
    FilterTemplateItemsEvent event,
    Emitter<TemplateState> emit,
  ) async {
    if (state is TemplateLoaded) {
      emit(const TemplateLoading());

      final result = await getTemplateItemsUseCase(
        GetTemplateItemsParams(
          fromDate: event.fromDate,
          toDate: event.toDate,
          isActive: event.isActive,
        ),
      );

      result.fold(
        (failure) => emit(TemplateError(message: _mapFailureToMessage(failure))),
        (items) => emit(TemplateLoaded(
          items: items,
          filteredItems: items,
          isFiltered: event.fromDate != null || event.toDate != null || event.isActive != null,
          currentFromDate: event.fromDate,
          currentToDate: event.toDate,
          currentIsActiveFilter: event.isActive,
        ),),
      );
    }
  }

  Future<void> _onRefreshTemplateItems(
    RefreshTemplateItemsEvent event,
    Emitter<TemplateState> emit,
  ) async {
    if (state is TemplateLoaded) {
      final currentState = state as TemplateLoaded;
      
      final result = await getTemplateItemsUseCase(
        GetTemplateItemsParams(
          fromDate: currentState.currentFromDate,
          toDate: currentState.currentToDate,
          isActive: currentState.currentIsActiveFilter,
          searchQuery: currentState.currentSearchQuery,
        ),
      );

      result.fold(
        (failure) => emit(currentState.copyWith(error: _mapFailureToMessage(failure))),
        (items) => emit(currentState.copyWith(
          items: items,
          filteredItems: items,
        ),),
      );
    }
  }

  List<TemplateEntity> _applyCurrentFilters(
    List<TemplateEntity> items,
    TemplateLoaded state,
  ) {
    var filtered = items;

    if (state.currentSearchQuery?.isNotEmpty ?? false) {
      final query = state.currentSearchQuery!.toLowerCase();
      filtered = filtered.where((item) =>
        item.title.toLowerCase().contains(query) ||
        item.description.toLowerCase().contains(query),
      ).toList();
    }

    if (state.currentFromDate != null) {
      filtered = filtered.where((item) => 
        item.createdAt.isAfter(state.currentFromDate!),
      ).toList();
    }

    if (state.currentToDate != null) {
      filtered = filtered.where((item) => 
        item.createdAt.isBefore(state.currentToDate!),
      ).toList();
    }

    if (state.currentIsActiveFilter != null) {
      filtered = filtered.where((item) => 
        item.isActive == state.currentIsActiveFilter,
      ).toList();
    }

    return filtered;
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Server error occurred';
      case CacheFailure _:
        return 'Cache error occurred';
      case DatabaseFailure _:
        return (failure as DatabaseFailure).msg;
      default:
        return 'Unexpected error occurred';
    }
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}