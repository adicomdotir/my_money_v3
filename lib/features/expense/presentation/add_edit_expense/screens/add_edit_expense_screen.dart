import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/core/widgets/error_widget.dart' as error_widget;
import 'package:my_money_v3/shared/domain/entities/expense.dart';

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
          return error_widget.ErrorWidget(
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
      expense = args['expense'];
    }

    final appBar = AppBar(
      title: expense == null ? Text('هزینه جدید') : Text('ویرایش هزینه'),
    );
    return Scaffold(
      appBar: appBar,
      body: _buildBodyContent(),
    );
  }
}
