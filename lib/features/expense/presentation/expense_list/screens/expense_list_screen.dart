import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/core/utils/utils.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../../../shared/widgets/widgets.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<ExpenseCubit>(context).changeCalenderFilterType(0);
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
          return AppErrorWidget(
            onPress: () {},
          );
        } else {
          return Column(
            children: [
              CalenderFilterWidget(),
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
      title: Text('هزینه ها'),
    );
    return Scaffold(
      appBar: appBar,
      body: _buildBodyContent(),
    );
  }
}

class CalenderFilterWidget extends StatelessWidget {
  CalenderFilterWidget({super.key});

  final PageController _pageController = PageController();

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
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.arrow_left),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (value) {
                        BlocProvider.of<ExpenseCubit>(context)
                            .changeCalenderFilterType(value);
                      },
                      children: [
                        Center(child: Text(calenderFilters[0])),
                        Center(child: Text(calenderFilters[1])),
                        Center(child: Text(calenderFilters[2])),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (calenderFilterType > 0) {
                        BlocProvider.of<ExpenseCubit>(context)
                            .changeCalenderFilterType(calenderFilterType - 1);
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
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

  Widget subFilterBuild(
    BuildContext context,
    void Function() leftTap,
    void Function() rightTap,
    Widget widget,
  ) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: leftTap,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_left),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: widget,
          ),
          GestureDetector(
            onTap: rightTap,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.15,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_right),
            ),
          ),
        ],
      ),
    );
  }

  Widget forDaysBuild(ExpenseState state, BuildContext context) {
    return subFilterBuild(
      context,
      () {
        BlocProvider.of<ExpenseCubit>(context)
            .changeFromDate(state.fromDate?.addDays(1) ?? Jalali.now());
      },
      () {
        BlocProvider.of<ExpenseCubit>(context)
            .changeFromDate(state.fromDate?.addDays(-1) ?? Jalali.now());
      },
      Text(
        '${state.fromDate?.day.toString()} ${getPersianMonthName((state.fromDate?.month ?? 1) - 1)}',
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget forWeekBuild(ExpenseState state, BuildContext context) {
    return subFilterBuild(
      context,
      () {
        BlocProvider.of<ExpenseCubit>(context)
            .changeFromDate(state.fromDate?.addDays(7) ?? Jalali.now());
      },
      () {
        BlocProvider.of<ExpenseCubit>(context)
            .changeFromDate(state.fromDate?.addDays(-7) ?? Jalali.now());
      },
      Text(
        '${state.fromDate?.formatShortMonthDay()} تا ${state.fromDate?.addDays(6).formatShortMonthDay()}',
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget forMonthBuild(ExpenseState state, BuildContext context) {
    return subFilterBuild(
      context,
      () {
        Jalali monthStart = state.fromDate?.addMonths(1) ?? Jalali.now();
        monthStart = Jalali(monthStart.year, monthStart.month, 1);
        BlocProvider.of<ExpenseCubit>(context).changeFromDate(monthStart);
      },
      () {
        Jalali monthStart = state.fromDate?.addMonths(-1) ?? Jalali.now();
        monthStart = Jalali(monthStart.year, monthStart.month, 1);
        BlocProvider.of<ExpenseCubit>(context).changeFromDate(monthStart);
      },
      Text(
        '${getPersianMonthName((state.fromDate?.month ?? 1) - 1)} ${state.fromDate?.year}',
        textAlign: TextAlign.center,
      ),
    );
  }
}
