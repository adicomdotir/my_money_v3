import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/template_entity.dart';

/// Repository interface - defines the contract for data operations
/// This belongs in the domain layer and should not depend on data layer
abstract class TemplateRepository {
  /// Get all template items with optional filtering
  Future<Either<Failure, List<TemplateEntity>>> getTemplateItems({
    DateTime? fromDate,
    DateTime? toDate,
    bool? isActive,
    String? searchQuery,
  });

  /// Get a single template item by ID
  Future<Either<Failure, TemplateEntity>> getTemplateItemById(String id);

  /// Create a new template item
  Future<Either<Failure, TemplateEntity>> createTemplateItem(TemplateEntity item);

  /// Update an existing template item
  Future<Either<Failure, TemplateEntity>> updateTemplateItem(TemplateEntity item);

  /// Delete a template item
  Future<Either<Failure, void>> deleteTemplateItem(String id);

  /// Batch operations
  Future<Either<Failure, List<TemplateEntity>>> createMultipleItems(
    List<TemplateEntity> items,
  );

  /// Check if item exists
  Future<Either<Failure, bool>> itemExists(String id);

  /// Get items count
  Future<Either<Failure, int>> getItemsCount({bool? isActive});
}