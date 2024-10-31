import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/config/locale/app_localizations.dart';
import 'package:my_money_v3/core/utils/functions/functions.dart';
import 'package:my_money_v3/core/widgets/error_widget.dart' as error_widget;
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../cubit/expense_cubit.dart';
import '../widgets/expense_list_content.dart';

List<String> calenderFilters = ['روز', 'هفته', 'ماه'];

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildBodyContent() {
    return BlocConsumer<ExpenseCubit, ExpenseState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.loading != null && state.loading == true) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.error != null) {
          return error_widget.ErrorWidget(
            onPress: () {},
          );
        } else {
          return Column(
            children: [
              const CalenderFilterWidget(),
              ExpenseListContent(
                expenses: state.expenses ?? [],
              ),
            ],
          );
        }
      },
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

class CalenderFilterWidget extends StatelessWidget {
  const CalenderFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseState>(
      builder: (context, state) {
        int calenderFilterType = state.calenderFilterType ?? 0;

        return Column(
          children: [
            SizedBox(
              height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (calenderFilters.length > calenderFilterType + 1) {
                        BlocProvider.of<ExpenseCubit>(context)
                            .changeCalenderFilterType(calenderFilterType + 1);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: const Icon(Icons.arrow_left),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      calenderFilters[calenderFilterType],
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (calenderFilterType > 0) {
                        BlocProvider.of<ExpenseCubit>(context)
                            .changeCalenderFilterType(calenderFilterType - 1);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: const Icon(Icons.arrow_right),
                    ),
                  ),
                ],
              ),
            ),
            if (calenderFilterType == 0) forDaysBuild(state, context),
            if (calenderFilterType == 1) forWeekBuild(state, context),
            if (calenderFilterType == 2) forMonthBuild(state, context),
          ],
        );
      },
    );
  }

  Widget forDaysBuild(ExpenseState state, BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              BlocProvider.of<ExpenseCubit>(context)
                  .changeFromDate(state.fromDate?.addDays(1) ?? Jalali.now());
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: const Icon(Icons.arrow_left),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text(
              '${state.fromDate?.day.toString()} ${getMonthName((state.fromDate?.month ?? 1) - 1)}',
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () {
              BlocProvider.of<ExpenseCubit>(context)
                  .changeFromDate(state.fromDate?.addDays(-1) ?? Jalali.now());

              // _getDateByDayFilter();
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: const Icon(Icons.arrow_right),
            ),
          ),
        ],
      ),
    );
  }

  Widget forWeekBuild(ExpenseState state, BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              BlocProvider.of<ExpenseCubit>(context)
                  .changeFromDate(state.fromDate?.addDays(7) ?? Jalali.now());
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: const Icon(Icons.arrow_left),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text(
              '${state.fromDate?.formatShortMonthDay()} تا ${state.fromDate?.addDays(6).formatShortMonthDay()}',
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () {
              BlocProvider.of<ExpenseCubit>(context)
                  .changeFromDate(state.fromDate?.addDays(-7) ?? Jalali.now());
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: const Icon(Icons.arrow_right),
            ),
          ),
        ],
      ),
    );
  }

  Widget forMonthBuild(ExpenseState state, BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Jalali monthStart = state.fromDate?.addMonths(1) ?? Jalali.now();
              monthStart = Jalali(monthStart.year, monthStart.month, 1);
              BlocProvider.of<ExpenseCubit>(context).changeFromDate(monthStart);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: const Icon(Icons.arrow_left),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text(
              '${getMonthName((state.fromDate?.month ?? 1) - 1)} ${state.fromDate?.year}',
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () {
              Jalali monthStart = state.fromDate?.addMonths(-1) ?? Jalali.now();
              monthStart = Jalali(monthStart.year, monthStart.month, 1);
              BlocProvider.of<ExpenseCubit>(context).changeFromDate(monthStart);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: const Icon(Icons.arrow_right),
            ),
          ),
        ],
      ),
    );
  }
}
