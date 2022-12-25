import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/domain/usecases/usecase.dart';
import '../repositories/expense_list_repository.dart';

class DeleteExpenseUseCase implements UseCase<void, DeleteExpenseParams> {
  final ExpenseListRepository expenseListRepository;

  DeleteExpenseUseCase({required this.expenseListRepository});

  @override
  Future<Either<Failure, void>> call(DeleteExpenseParams params) =>
      expenseListRepository.deleteExpense(params.id);
}

class DeleteExpenseParams extends Equatable {
  final String id;

  const DeleteExpenseParams(this.id);

  @override
  List<Object?> get props => [id];
}
