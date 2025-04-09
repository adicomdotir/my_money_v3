import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/entities/expense.dart';
import '../repositories/filter_expense_repository.dart';

class GetFilterExpenseUseCase
    implements UseCaseWithParam<List<Expense>, GetFilterExpenseParams> {
  final FilterExpenseRepository repository;

  GetFilterExpenseUseCase({required this.repository});

  @override
  Future<Either<Failure, List<Expense>>> call(GetFilterExpenseParams params) =>
      repository.getExpenses(params.fromDate, params.toDate, params.categoryId);
}

class GetFilterExpenseParams extends Equatable {
  final int? fromDate;
  final int? toDate;
  final String? categoryId;

  const GetFilterExpenseParams([this.fromDate, this.toDate, this.categoryId]);

  @override
  List<Object?> get props => [fromDate, toDate, categoryId];
}
