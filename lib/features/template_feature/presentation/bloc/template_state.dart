part of 'template_bloc.dart';

/// Base state class for Template BLoC
abstract class TemplateState extends Equatable {
  const TemplateState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class TemplateInitial extends TemplateState {
  const TemplateInitial();
}

/// Loading state
class TemplateLoading extends TemplateState {
  const TemplateLoading();
}

/// Loaded state with data
class TemplateLoaded extends TemplateState {
  final List<TemplateEntity> items;
  final List<TemplateEntity> filteredItems;
  final bool isFiltered;
  final bool isCreating;
  final String? error;
  final TemplateEntity? lastCreatedItem;
  
  // Current filter values
  final DateTime? currentFromDate;
  final DateTime? currentToDate;
  final bool? currentIsActiveFilter;
  final String? currentSearchQuery;

  const TemplateLoaded({
    required this.items,
    required this.filteredItems,
    this.isFiltered = false,
    this.isCreating = false,
    this.error,
    this.lastCreatedItem,
    this.currentFromDate,
    this.currentToDate,
    this.currentIsActiveFilter,
    this.currentSearchQuery,
  });

  /// Helper getters
  List<TemplateEntity> get displayItems => isFiltered ? filteredItems : items;
  int get totalCount => items.length;
  int get filteredCount => filteredItems.length;
  bool get hasActiveFilter => currentFromDate != null || 
                               currentToDate != null || 
                               currentIsActiveFilter != null ||
                               (currentSearchQuery?.isNotEmpty ?? false);

  /// Copy with method for state updates
  TemplateLoaded copyWith({
    List<TemplateEntity>? items,
    List<TemplateEntity>? filteredItems,
    bool? isFiltered,
    bool? isCreating,
    String? error,
    TemplateEntity? lastCreatedItem,
    DateTime? currentFromDate,
    DateTime? currentToDate,
    bool? currentIsActiveFilter,
    String? currentSearchQuery,
  }) {
    return TemplateLoaded(
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      isFiltered: isFiltered ?? this.isFiltered,
      isCreating: isCreating ?? this.isCreating,
      error: error,
      lastCreatedItem: lastCreatedItem,
      currentFromDate: currentFromDate ?? this.currentFromDate,
      currentToDate: currentToDate ?? this.currentToDate,
      currentIsActiveFilter: currentIsActiveFilter ?? this.currentIsActiveFilter,
      currentSearchQuery: currentSearchQuery ?? this.currentSearchQuery,
    );
  }

  @override
  List<Object?> get props => [
        items,
        filteredItems,
        isFiltered,
        isCreating,
        error,
        lastCreatedItem,
        currentFromDate,
        currentToDate,
        currentIsActiveFilter,
        currentSearchQuery,
      ];
}

/// Error state
class TemplateError extends TemplateState {
  final String message;

  const TemplateError({required this.message});

  @override
  List<Object?> get props => [message];
}