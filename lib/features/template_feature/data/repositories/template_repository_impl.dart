import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../domain/entities/template_entity.dart';
import '../../domain/repositories/template_repository.dart';
import '../datasources/template_local_data_source.dart';
import '../models/template_model.dart';

/// Repository implementation with proper error handling
class TemplateRepositoryImpl implements TemplateRepository {
  final TemplateLocalDataSource localDataSource;

  TemplateRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<TemplateEntity>>> getTemplateItems({
    DateTime? fromDate,
    DateTime? toDate,
    bool? isActive,
    String? searchQuery,
  }) async {
    try {
      final models = await localDataSource.getTemplateItems(
        fromDate: fromDate,
        toDate: toDate,
        isActive: isActive,
        searchQuery: searchQuery,
      );

      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on Exception {
      return Left(CacheFailure());
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to get template items: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, TemplateEntity>> getTemplateItemById(String id) async {
    try {
      final model = await localDataSource.getTemplateItemById(id);
      return Right(model.toEntity());
    } on Exception catch (e) {
      if (e.toString().contains('not found')) {
        return Left(DatabaseFailure(message: 'Item not found'));
      }
      return Left(CacheFailure());
    } catch (e) {
      return Left(
        DatabaseFailure(message: 'Failed to get item: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, TemplateEntity>> createTemplateItem(
    TemplateEntity item,
  ) async {
    try {
      // Check if item already exists
      final exists = await localDataSource.itemExists(item.id);
      if (exists) {
        return Left(
          DatabaseFailure(message: 'Item with this ID already exists'),
        );
      }

      final model = TemplateModel.fromEntity(item);
      await localDataSource.createTemplateItem(model);
      return Right(item);
    } on Exception {
      return Left(CacheFailure());
    } catch (e) {
      return Left(
        DatabaseFailure(message: 'Failed to create item: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, TemplateEntity>> updateTemplateItem(
    TemplateEntity item,
  ) async {
    try {
      // Verify item exists before updating
      final exists = await localDataSource.itemExists(item.id);
      if (!exists) {
        return Left(
          DatabaseFailure(message: 'Cannot update non-existent item'),
        );
      }

      final model = TemplateModel.fromEntity(item);
      await localDataSource.updateTemplateItem(model);

      // Return updated entity with new timestamp
      final updatedEntity = item.copyWith(updatedAt: DateTime.now());
      return Right(updatedEntity);
    } on Exception {
      return Left(CacheFailure());
    } catch (e) {
      return Left(
        DatabaseFailure(message: 'Failed to update item: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteTemplateItem(String id) async {
    try {
      await localDataSource.deleteTemplateItem(id);
      return const Right(null);
    } on Exception catch (e) {
      if (e.toString().contains('non-existent')) {
        return Left(DatabaseFailure(message: 'Item not found'));
      }
      return Left(CacheFailure());
    } catch (e) {
      return Left(
        DatabaseFailure(message: 'Failed to delete item: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<TemplateEntity>>> createMultipleItems(
    List<TemplateEntity> items,
  ) async {
    try {
      // Check for duplicate IDs in the batch
      final ids = items.map((e) => e.id).toSet();
      if (ids.length != items.length) {
        return Left(DatabaseFailure(message: 'Duplicate IDs in batch'));
      }

      // Check if any items already exist
      for (final item in items) {
        final exists = await localDataSource.itemExists(item.id);
        if (exists) {
          return Left(
            DatabaseFailure(message: 'Item ${item.id} already exists'),
          );
        }
      }

      final models = items.map((e) => TemplateModel.fromEntity(e)).toList();
      await localDataSource.createMultipleItems(models);
      return Right(items);
    } on Exception {
      return Left(CacheFailure());
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to create multiple items: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> itemExists(String id) async {
    try {
      final exists = await localDataSource.itemExists(id);
      return Right(exists);
    } on Exception {
      return Left(CacheFailure());
    } catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Failed to check if item exists: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, int>> getItemsCount({bool? isActive}) async {
    try {
      final count = await localDataSource.getItemsCount(isActive: isActive);
      return Right(count);
    } on Exception {
      return Left(CacheFailure());
    } catch (e) {
      return Left(
        DatabaseFailure(message: 'Failed to get items count: ${e.toString()}'),
      );
    }
  }
}
