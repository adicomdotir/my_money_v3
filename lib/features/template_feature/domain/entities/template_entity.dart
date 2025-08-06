import 'package:equatable/equatable.dart';

/// This is a domain entity - it should contain only business logic
/// and be independent of any external layers or frameworks
class TemplateEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final double? amount;
  final Map<String, dynamic>? metadata;

  const TemplateEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.isActive,
    this.updatedAt,
    this.amount,
    this.metadata,
  });

  /// Computed properties
  bool get hasAmount => amount != null && amount! > 0;

  /// Business logic methods
  bool isOlderThan(Duration duration) {
    return DateTime.now().difference(createdAt) > duration;
  }

  /// Create a copy with updated fields
  TemplateEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    double? amount,
    Map<String, dynamic>? metadata,
  }) {
    return TemplateEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      amount: amount ?? this.amount,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        createdAt,
        updatedAt,
        isActive,
        amount,
        metadata,
      ];
}
