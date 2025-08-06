import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/routes/app_routes.dart';
import '../../../../../core/bloc/global_bloc.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/domain/entities/expense.dart';
import '../cubit/expense_cubit.dart';

class ExpenseListContent extends StatefulWidget {
  final List<Expense> expenses;

  const ExpenseListContent({
    required this.expenses,
    super.key,
  });

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
        margin: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: widget.expenses.length,
          itemBuilder: (context, index) {
            return ExpenseCard(
              expense: widget.expenses[index],
            );
          },
        ),
      ),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard({
    required this.expense,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.addEditExpanseRoute,
          arguments: {
            'expense': Expense(
              id: expense.id,
              title: expense.title,
              price: expense.price,
              date: expense.date,
              categoryId: expense.categoryId,
            ),
          },
        ).then((value) {
          if (context.mounted) {
            BlocProvider.of<ExpenseCubit>(context).getExpenses();
          }
        });
      },
      child: Card(
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          height: 100,
          child: Row(
            children: [
              Container(
                width: 10,
                height: 50,
                color: HexColor(expense.category!.color),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(expense.title),
                        Text(
                          formatPrice(
                            expense.price,
                            context.read<GlobalBloc>().state.settings.unit,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'تاریخ: ${formatDate(expense.date)}',
                            ),
                            Text(expense.category!.title),
                          ],
                        ),
                        IconButton(
                          onPressed: () async {
                            await showDeleteDialog(context).then((value) {
                              if (context.mounted && value != null && value) {
                                BlocProvider.of<ExpenseCubit>(context)
                                    .deleteExpense(expense.id);
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool?> showDeleteDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text('ایا برای حذف ایتم مطمئن هستید؟'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text('بله'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text('خیر'),
          ),
        ],
      );
    },
  );
}
