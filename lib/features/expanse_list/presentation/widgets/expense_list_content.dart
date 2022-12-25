import 'package:flutter/material.dart';
import 'package:my_money_v3/config/locale/app_localizations.dart';
import 'package:my_money_v3/config/routes/app_routes.dart';
import 'package:my_money_v3/core/utils/date_format.dart';

import '../../domain/entities/expense.dart';

class ExpenseListContent extends StatefulWidget {
  final List<Expense> expenses;

  const ExpenseListContent({
    Key? key,
    required this.expenses,
  }) : super(key: key);

  @override
  State<ExpenseListContent> createState() => _ExpenseListContentState();
}

class _ExpenseListContentState extends State<ExpenseListContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: widget.expenses.length,
          itemBuilder: (context, index) {
            return ExpenseCard(expense: widget.expenses[index]);
          },
        ),
      ),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          Text(expense.title),
          Text(expense.price.toString()),
          Text(expense.categoryId),
          Text(dateFormat(expense.date)),
        ],
      ),
    );
  }
}
