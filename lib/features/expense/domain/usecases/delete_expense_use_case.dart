import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:my_money_v3/features/expense/domain/repositories/expense_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';

class DeleteExpenseUseCase implements UseCase<void, DeleteExpenseParams> {
  final ExpenseRepository expenseRepository;

  DeleteExpenseUseCase({required this.expenseRepository});

  @override
  Future<Either<Failure, void>> call(DeleteExpenseParams params) =>
      expenseRepository.deleteExpense(params.id);
}

class DeleteExpenseParams extends Equatable {
  final String id;

  const DeleteExpenseParams(this.id);

  @override
  List<Object?> get props => [id];
}
