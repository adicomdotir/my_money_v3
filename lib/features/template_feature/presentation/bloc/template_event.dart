part of 'template_bloc.dart';

/// Base event class for Template BLoC
abstract class TemplateEvent extends Equatable {
  const TemplateEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load template items
class LoadTemplateItemsEvent extends TemplateEvent {
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool? isActive;

  const LoadTemplateItemsEvent({
    this.fromDate,
    this.toDate,
    this.isActive,
  });

  @override
  List<Object?> get props => [fromDate, toDate, isActive];
}

/// Event to create a new template item
class CreateTemplateItemEvent extends TemplateEvent {
  final String title;
  final String description;
  final bool isActive;
  final double? amount;
  final Map<String, dynamic>? metadata;

  const CreateTemplateItemEvent({
    required this.title,
    required this.description,
    this.isActive = true,
    this.amount,
    this.metadata,
  });

  @override
  List<Object?> get props => [title, description, isActive, amount, metadata];
}

/// Event to search template items
class SearchTemplateItemsEvent extends TemplateEvent {
  final String query;

  const SearchTemplateItemsEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Event to filter template items
class FilterTemplateItemsEvent extends TemplateEvent {
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool? isActive;

  const FilterTemplateItemsEvent({
    this.fromDate,
    this.toDate,
    this.isActive,
  });

  @override
  List<Object?> get props => [fromDate, toDate, isActive];
}

/// Event to refresh current items
class RefreshTemplateItemsEvent extends TemplateEvent {
  const RefreshTemplateItemsEvent();
}