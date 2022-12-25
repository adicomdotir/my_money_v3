import 'package:my_money_v3/core/widgets/error_widget.dart' as error_widget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_money_v3/features/expanse_list/presentation/cubit/expense_list_cubit.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../widgets/expense_list_content.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  _getExpenses() => BlocProvider.of<ExpenseListCubit>(context).getExpenses();

  @override
  void initState() {
    _getExpenses();
    super.initState();
  }

  Widget _buildBodyContent() {
    return BlocBuilder<ExpenseListCubit, ExpenseListState>(
      builder: ((context, state) {
        if (state is ExpenseListIsLoading) {
          return Center(
            child: SpinKitFadingCircle(
              color: AppColors.primary,
            ),
          );
        } else if (state is ExpenseListError) {
          return error_widget.ErrorWidget(
            onPress: () {},
          );
        } else if (state is ExpenseListLoaded) {
          return Column(
            children: [
              ExpenseListContent(
                expenses: state.expenses,
              ),
            ],
          );
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
