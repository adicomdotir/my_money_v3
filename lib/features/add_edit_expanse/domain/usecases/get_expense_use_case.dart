import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class GetExpenseUseCase implements UseCase<Expense, NoParams> {
  final ExpenseRepository expenseRepository;

  GetExpenseUseCase({required this.expenseRepository});

  @override
  Future<Either<Failure, Expense>> call(NoParams params) =>
      expenseRepository.getExpense();
}
