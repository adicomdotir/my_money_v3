import 'package:my_money_v3/core/widgets/error_widget.dart' as error_widget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/domain/entities/expense.dart';
import '../../../../core/utils/app_colors.dart';
import '../cubit/expense_cubit.dart';
import '../widgets/add_edit_expense_content.dart';

class AddEditExpenseScreen extends StatefulWidget {
  const AddEditExpenseScreen({Key? key}) : super(key: key);

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
    // _getCategories();
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: ((context, state) {
        if (state is ExpenseIsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ExpenseError) {
          return error_widget.ErrorWidget(
            onPress: () {},
          );
        } else if (state is AddEditExpenseLoaded) {
          return Column(
            children: [
              // AddEditExpenseContent(
              //   expense: state.expense,
              //   categories: [],
              // ),
              InkWell(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: const Icon(
                    Icons.refresh,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        } else {
          return const AddEditExpenseContent(
            categories: [],
          );
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.settings.arguments != null) {
      final args = ModalRoute.of(context)?.settings.arguments as Map;
      expense = args['expense'];
    }

    final appBar = AppBar(
      title: expense == null
          ? Text(AppLocalizations.of(context)!.translate('add_expense')!)
          : Text(AppLocalizations.of(context)!.translate('edit_expense')!),
    );
    return Scaffold(
      appBar: appBar,
      body: _buildBodyContent(),
    );
  }
}
