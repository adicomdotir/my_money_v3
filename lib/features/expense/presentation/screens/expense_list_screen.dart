import 'package:my_money_v3/core/utils/app_colors.dart';
import 'package:my_money_v3/core/widgets/error_widget.dart' as error_widget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../../config/locale/app_localizations.dart';
import '../cubit/expense_cubit.dart';
import '../widgets/expense_list_content.dart';

List<String> calenderFilters = ['روز', 'هفته', 'ماه'];

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  Future<void> _getExpenses([int? fromDate, int? toDate]) =>
      BlocProvider.of<ExpenseCubit>(context).getExpenses(fromDate, toDate);

  @override
  void initState() {
    var startDate = Jalali.now();
    startDate = Jalali(startDate.year, startDate.month, startDate.day);
    final endDate = startDate.addDays(1);
    _getExpenses(
      startDate.toDateTime().millisecondsSinceEpoch,
      endDate.toDateTime().millisecondsSinceEpoch,
    );
    super.initState();
  }

  Widget _buildBodyContent() {
    return BlocConsumer<ExpenseCubit, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseDeleteSuccess) {
          _getExpenses();
        }
      },
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
              const CalenderFilterWidget(),
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

class CalenderFilterWidget extends StatefulWidget {
  const CalenderFilterWidget({super.key});

  @override
  State<CalenderFilterWidget> createState() => _CalenderFilterWidgetState();
}

class _CalenderFilterWidgetState extends State<CalenderFilterWidget> {
  int calenderFilterType = 0;
  Jalali _jalali = Jalali.now();
  Jalali weekStart = Jalali.now().add(days: (1 - Jalali.now().weekDay));
  Jalali monthStart = Jalali.now();
  int weekIndex = 0;

  Future<void> _getExpenses([int? fromDate, int? toDate]) =>
      BlocProvider.of<ExpenseCubit>(context).getExpenses(fromDate, toDate);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (calenderFilters.length > calenderFilterType + 1) {
                      calenderFilterType = calenderFilterType + 1;
                      _callFilter();
                    }
                  });
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
                  setState(() {
                    if (calenderFilterType > 0) {
                      calenderFilterType = calenderFilterType - 1;
                      _callFilter();
                    }
                  });
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
        if (calenderFilterType == 0) forDaysBuild(),
        if (calenderFilterType == 1) forWeekBuild(),
        if (calenderFilterType == 2) forMonthBuild(),
      ],
    );
  }

  Widget forDaysBuild() {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _jalali = _jalali.addDays(1);
              });

              _getDateByDayFilter();
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
              '${_jalali.day.toString()} ${JalaliDate.months[_jalali.month - 1]}',
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _jalali = _jalali.addDays(-1);
              });

              _getDateByDayFilter();
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

  Widget forWeekBuild() {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                weekStart = weekStart.addDays(7);
              });

              _getDateByWeekFilter();
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
              '${weekStart.formatShortMonthDay()} تا ${weekStart.addDays(6).formatShortMonthDay()}',
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                weekStart = weekStart.addDays(-7);
              });

              _getDateByWeekFilter();
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

  Widget forMonthBuild() {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                monthStart = monthStart.addMonths(1);
                monthStart = Jalali(monthStart.year, monthStart.month, 1);
              });

              _getDateByMonthFilter();
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
              '${JalaliDate.months[monthStart.month - 1]} ${monthStart.year}',
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                monthStart = monthStart.addMonths(-1);
                monthStart = Jalali(monthStart.year, monthStart.month, 1);
              });

              _getDateByMonthFilter();
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

  void _getDateByDayFilter() {
    final endDate = _jalali.addDays(1).toDateTime().millisecondsSinceEpoch;
    _getExpenses(
      _jalali.toDateTime().millisecondsSinceEpoch,
      endDate,
    );
  }

  void _getDateByWeekFilter() {
    final endDate = weekStart.addDays(7).toDateTime().millisecondsSinceEpoch;
    _getExpenses(
      weekStart.toDateTime().millisecondsSinceEpoch,
      endDate,
    );
  }

  void _getDateByMonthFilter() {
    final endDate = monthStart.addMonths(1).toDateTime().millisecondsSinceEpoch;
    _getExpenses(
      monthStart.toDateTime().millisecondsSinceEpoch,
      endDate,
    );
  }

  void _callFilter() {
    if (calenderFilterType == 0) {
      _getDateByDayFilter();
    } else if (calenderFilterType == 1) {
      _getDateByWeekFilter();
    } else if (calenderFilterType == 2) {
      _getDateByMonthFilter();
    }
  }
}
