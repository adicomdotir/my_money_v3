import 'package:my_money_v3/core/widgets/error_widget.dart' as error_widget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/locale/app_localizations.dart';
import '../cubit/expense_cubit.dart';
import '../widgets/expense_list_content.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  _getExpenses() => BlocProvider.of<ExpenseCubit>(context).getExpenses();

  @override
  void initState() {
    _getExpenses();
    super.initState();
  }

  Widget _buildBodyContent() {
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
        } else if (state is ExpenseLoaded) {
          return Column(
            children: [
              ExpenseListContent(
                expenses: state.expenses,
              ),
            ],
          );
        } else if (state is ExpenseDeleteSuccess) {
          _getExpenses();
          return Container();
        } else {
          return const ExpenseListContent(
            expenses: [],
          );
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(AppLocalizations.of(context)!.translate('expenses')!),
    );
    return Scaffold(
      appBar: appBar,
      body: _buildBodyContent(),
    );
  }
}
