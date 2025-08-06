import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../entities/template_entity.dart';
import '../repositories/template_repository.dart';

/// Use case for getting template items with filtering
class GetTemplateItemsUseCase
    extends UseCaseWithParam<List<TemplateEntity>, GetTemplateItemsParams> {
  final TemplateRepository repository;

  GetTemplateItemsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<TemplateEntity>>> call(
      GetTemplateItemsParams params) async {
    // Business logic validation before calling repository
    if (params.fromDate != null && params.toDate != null) {
      if (params.fromDate!.isAfter(params.toDate!)) {
        return Left(
            DatabaseFailure(message: 'From date cannot be after to date'));
      }
    }

    return await repository.getTemplateItems(
      fromDate: params.fromDate,
      toDate: params.toDate,
      isActive: params.isActive,
      searchQuery: params.searchQuery,
    );
  }
}

/// Parameters for GetTemplateItemsUseCase
class GetTemplateItemsParams extends Equatable {
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool? isActive;
  final String? searchQuery;

  const GetTemplateItemsParams({
    this.fromDate,
    this.toDate,
    this.isActive,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [fromDate, toDate, isActive, searchQuery];
}
