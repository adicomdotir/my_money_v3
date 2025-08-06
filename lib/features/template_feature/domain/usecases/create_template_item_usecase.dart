import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../entities/template_entity.dart';
import '../repositories/template_repository.dart';

/// Use case for creating a new template item
class CreateTemplateItemUseCase
    extends UseCaseWithParam<TemplateEntity, CreateTemplateItemParams> {
  final TemplateRepository repository;
  final Uuid _uuid = const Uuid();

  CreateTemplateItemUseCase({required this.repository});

  @override
  Future<Either<Failure, TemplateEntity>> call(
    CreateTemplateItemParams params,
  ) async {
    // Validate input
    if (params.title.trim().isEmpty) {
      return Left(DatabaseFailure('Title cannot be empty'));
    }

    if (params.title.length < 3) {
      return Left(DatabaseFailure('Title must be at least 3 characters long'));
    }

    // Create entity with generated ID and timestamp
    final entity = TemplateEntity(
      id: _uuid.v4(),
      title: params.title.trim(),
      description: params.description.trim(),
      createdAt: DateTime.now(),
      isActive: params.isActive,
      amount: params.amount,
      metadata: params.metadata,
    );

    return await repository.createTemplateItem(entity);
  }
}

/// Parameters for creating a template item
class CreateTemplateItemParams {
  final String title;
  final String description;
  final bool isActive;
  final double? amount;
  final Map<String, dynamic>? metadata;

  const CreateTemplateItemParams({
    required this.title,
    required this.description,
    this.isActive = true,
    this.amount,
    this.metadata,
  });
}
