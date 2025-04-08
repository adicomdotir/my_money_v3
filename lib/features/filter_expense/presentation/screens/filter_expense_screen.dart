import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/filter_expense/presentation/bloc/filter_expnese_bloc.dart';
import 'package:my_money_v3/shared/domain/entities/expense.dart';

class FilterExpenseScreen extends StatelessWidget {
  const FilterExpenseScreen({super.key});

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
        if (state is FilterExpenseInitial) {
          return _showListView();
        } else {
          return Column(
            children: [
              Text('data'),
            ],
          );
        }
      },
    );
  }

  Widget _showListView() {
    return ListView.builder(
      itemCount: fakeList.length,
      itemBuilder: (context, index) {
        final expense = fakeList[index];
        return ListTile(
          title: Text(expense.title),
          subtitle: Text(expense.price.toString()),
        );
      },
    );
  }
}

final fakeList = <Expense>[
  Expense(id: '1', title: 'title1', price: 100000, date: 1, categoryId: '1'),
  Expense(id: '2', title: 'title2', price: 150000, date: 1, categoryId: '1'),
  Expense(id: '3', title: 'title3', price: 210000, date: 1, categoryId: '1'),
  Expense(id: '4', title: 'title4', price: 250000, date: 1, categoryId: '1'),
];
