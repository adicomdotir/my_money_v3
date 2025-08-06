part of 'template_simple_cubit.dart';

enum TemplateStatus { initial, loading, loaded, submitting, error }

class TemplateSimpleState extends Equatable {
  final TemplateStatus status;
  final List<TemplateEntity> items;
  final String? errorMessage;
  final bool? filterIsActive;
  final String searchQuery;

  const TemplateSimpleState({
    this.status = TemplateStatus.initial,
    this.items = const [],
    this.errorMessage,
    this.filterIsActive,
    this.searchQuery = '',
  });

  /// Filtered items based on current filters
  List<TemplateEntity> get filteredItems {
    var filtered = items;

    // Apply active filter
    if (filterIsActive != null) {
      filtered =
          filtered.where((item) => item.isActive == filterIsActive).toList();
    }

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (item) =>
                item.title.toLowerCase().contains(query) ||
                item.description.toLowerCase().contains(query),
          )
          .toList();
    }

    return filtered;
  }

  /// Helper getters
  bool get isLoading => status == TemplateStatus.loading;
  bool get isSubmitting => status == TemplateStatus.submitting;
  bool get hasError => status == TemplateStatus.error;
  bool get hasFilters => filterIsActive != null || searchQuery.isNotEmpty;
  int get activeCount => items.where((item) => item.isActive).length;
  int get inactiveCount => items.where((item) => !item.isActive).length;

  TemplateSimpleState copyWith({
    TemplateStatus? status,
    List<TemplateEntity>? items,
    String? errorMessage,
    bool? filterIsActive,
    String? searchQuery,
  }) {
    return TemplateSimpleState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
      filterIsActive: filterIsActive ?? this.filterIsActive,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        errorMessage,
        filterIsActive,
        searchQuery,
      ];
}
