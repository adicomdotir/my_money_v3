import 'package:hive/hive.dart';

import '../../domain/entities/template_entity.dart';

// Run build_runner to generate: flutter pub run build_runner build --delete-conflicting-outputs
// part 'template_model.g.dart';

/// Data model for template feature
/// This is used for data persistence and should map to/from entity
@HiveType(typeId: 10) // Make sure this typeId is unique in your app
class TemplateModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime? updatedAt;

  @HiveField(5)
  final bool isActive;

  @HiveField(6)
  final double? amount;

  @HiveField(7)
  final Map<String, dynamic>? metadata;

  TemplateModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.isActive,
    this.updatedAt,
    this.amount,
    this.metadata,
  });

  /// Convert from Entity to Model (for storage)
  factory TemplateModel.fromEntity(TemplateEntity entity) {
    return TemplateModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isActive: entity.isActive,
      amount: entity.amount,
      metadata: entity.metadata,
    );
  }

  /// Convert from Model to Entity (for domain use)
  TemplateEntity toEntity() {
    return TemplateEntity(
      id: id,
      title: title,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
      amount: amount,
      metadata: metadata,
    );
  }

  /// Create from JSON (for API responses)
  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      isActive: json['isActive'] as bool,
      amount:
          json['amount'] != null ? (json['amount'] as num).toDouble() : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
      'amount': amount,
      'metadata': metadata,
    };
  }

  /// Create a copy with updated fields
  TemplateModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    double? amount,
    Map<String, dynamic>? metadata,
  }) {
    return TemplateModel(
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
}
