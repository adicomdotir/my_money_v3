import 'package:dartz/dartz.dart';
import 'package:my_money_v3/features/expense/domain/repositories/expense_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/domain/usecases/usecase.dart';
import '../../../../core/domain/entities/expense.dart';

class ExpenseListUseCase implements UseCase<List<Expense>, NoParams> {
  final ExpenseRepository expenseRepository;

  ExpenseListUseCase({required this.expenseRepository});

  @override
  Future<Either<Failure, List<Expense>>> call(NoParams params) =>
      expenseRepository.getExpenses();
}
