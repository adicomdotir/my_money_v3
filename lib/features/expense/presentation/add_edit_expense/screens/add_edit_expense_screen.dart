import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/shared/domain/entities/expense.dart';

import '../../../../../shared/widgets/widgets.dart';
import '../cubit/add_edit_expense_cubit.dart';
import '../widgets/add_edit_expense_content.dart';

class AddEditExpenseScreen extends StatefulWidget {
  const AddEditExpenseScreen({super.key});

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  Expense? expense;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildBodyContent() {
    return BlocConsumer<AddEditExpenseCubit, AddExpState>(
      listener: (context, state) {
        if (state is AddExpSuccess) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is AddExpIsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AddExpError) {
          return AppErrorWidget(
            onPress: () {},
          );
        } else {
          return AddEditExpenseContent(
            expense: expense,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.settings.arguments != null) {
      final args = ModalRoute.of(context)?.settings.arguments as Map;
      expense = args['expense'] as Expense?;
    }

    final appBar = AppBar(
      title: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            expense == null ? Icons.add_circle_outline : Icons.edit_note,
            size: 24,
          ),
          SizedBox(width: 8),
          Text(expense == null ? 'هزینه جدید' : 'ویرایش هزینه'),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: _buildBodyContent(),
    );
  }
}
