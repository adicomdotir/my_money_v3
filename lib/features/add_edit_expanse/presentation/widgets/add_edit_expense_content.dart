import 'package:flutter/material.dart';
import 'package:my_money_v3/features/add_edit_expanse/domain/entities/expense.dart';

import '../../../../core/utils/app_colors.dart';

class AddEditExpenseContent extends StatelessWidget {
  final Expense expense;

  const AddEditExpenseContent({Key? key, required this.expense})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Text(
            expense.content,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              expense.author,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        ],
      ),
    );
  }
}
