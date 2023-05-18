import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:my_money_v3/features/expense/domain/repositories/expense_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/domain/usecases/usecase.dart';
import '../../../../core/domain/entities/expense.dart';

class ExpenseListUseCase implements UseCase<List<Expense>, GetExpensesParams> {
  final ExpenseRepository expenseRepository;

  ExpenseListUseCase({required this.expenseRepository});

  @override
  Future<Either<Failure, List<Expense>>> call(GetExpensesParams params) =>
      expenseRepository.getExpenses(params.fromDate, params.toDate);
}

class GetExpensesParams extends Equatable {
  final int? fromDate;
  final int? toDate;

  const GetExpensesParams([this.fromDate, this.toDate]);

  @override
  List<Object?> get props => [fromDate, toDate];
}
