import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_list_repository.dart';

class ExpenseListUseCase implements UseCase<List<Expense>, NoParams> {
  final ExpenseListRepository expenseListRepository;

  ExpenseListUseCase({required this.expenseListRepository});

  @override
  Future<Either<Failure, List<Expense>>> call(NoParams params) =>
      expenseListRepository.getExpenses();
}
