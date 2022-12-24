import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:my_money_v3/features/add_edit_expanse/data/models/expense_model.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

class AddEditExpenseUseCase implements UseCase<int, ExpenseParams> {
  final ExpenseRepository expenseRepository;

  AddEditExpenseUseCase({required this.expenseRepository});

  @override
  Future<Either<Failure, int>> call(ExpenseParams expenseParams) =>
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
