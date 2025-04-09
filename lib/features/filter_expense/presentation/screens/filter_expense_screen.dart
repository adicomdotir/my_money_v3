import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/core/utils/date_format.dart';
import 'package:my_money_v3/core/utils/price_format.dart';
import 'package:my_money_v3/features/filter_expense/presentation/bloc/filter_expnese_bloc.dart';
import 'package:my_money_v3/shared/domain/entities/expense.dart';

import '../../../splash/presentation/bloc/global_bloc.dart';

class FilterExpenseScreen extends StatefulWidget {
  const FilterExpenseScreen({required this.id, super.key});

  final String id;

  @override
  State<FilterExpenseScreen> createState() => _FilterExpenseScreenState();
}

class _FilterExpenseScreenState extends State<FilterExpenseScreen> {
  @override
  void initState() {
    BlocProvider.of<FilterExpneseBloc>(context)
        .add(GetFilterExpenseEvent(widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text('فیلتر'),
    );
    return Scaffold(
      appBar: appBar,
      body: _buildBodyContent(),
    );
  }

  Widget _buildBodyContent() {
    return BlocConsumer<FilterExpneseBloc, FilterExpenseState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is FilterExpenseLoaded) {
          return _showListView(state.expenses);
        } else if (state is FilterExpenseInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Text('Error: unknown state');
        }
      },
    );
  }

  Widget _showListView(List<Expense> expenses) {
    final unit = context.read<GlobalBloc>().state.settings.unit;
    return Column(
      children: [
        SizedBox(
          height: 56,
          child: Center(
            child: Text(
              expenses.first.category?.title ?? 'Error',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return ListTile(
                title: Text(
                  expense.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  priceFormat(expense.price, unit),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: Text(
                  dateFormat(expense.date).toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
