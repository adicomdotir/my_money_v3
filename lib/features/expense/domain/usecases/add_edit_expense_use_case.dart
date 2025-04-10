import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:my_money_v3/shared/data/models/expense_model.dart';
import 'package:my_money_v3/shared/domain/entities/expense.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/expense_repository.dart';

class AddEditExpenseUseCase implements UseCaseWithParam<void, ExpenseParams> {
  final ExpenseRepository expenseRepository;

  AddEditExpenseUseCase({required this.expenseRepository});

  @override
  Future<Either<Failure, void>> call(ExpenseParams expenseParams) =>
      expenseRepository.addExpense(
        ExpenseModel(
          id: expenseParams.expense.id,
          title: expenseParams.expense.title,
          categoryId: expenseParams.expense.categoryId,
          date: expenseParams.expense.date,
          price: expenseParams.expense.price,
        ),
      );
}

class ExpenseParams extends Equatable {
  final Expense expense;

  const ExpenseParams(this.expense);

  @override
  List<Object?> get props => [expense];
}
