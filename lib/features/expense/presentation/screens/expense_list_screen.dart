import 'package:my_money_v3/core/utils/app_colors.dart';
import 'package:my_money_v3/core/widgets/error_widget.dart' as error_widget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../../config/locale/app_localizations.dart';
import '../cubit/expense_cubit.dart';
import '../widgets/expense_list_content.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  int selectedIdx = 0;
  int btnSelectIdx = 3;
  final Jalali _jalali = Jalali.now();
  ScrollController? _scrollController;
  _getExpenses([int? jalali]) =>
      BlocProvider.of<ExpenseCubit>(context).getExpenses(jalali);

  @override
  void initState() {
    _getExpenses();
    selectedIdx = (_jalali.day - 1);
    _scrollController = ScrollController(initialScrollOffset: selectedIdx * 40);
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
              Container(
                height: 60,
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    children: [
                      topBtn(
                        title: 'براساس روز',
                        selected: btnSelectIdx == 0,
                        isLeft: false,
                        isRight: true,
                        onTap: () {
                          setState(() {
                            btnSelectIdx = 0;
                          });
                          int jalali = Jalali(
                            _jalali.year,
                            _jalali.month,
                            _jalali.day,
                          ).toDateTime().millisecondsSinceEpoch;
                          _getExpenses(jalali);
                        },
                      ),
                      topBtn(
                        title: 'هفته اخیر',
                        selected: btnSelectIdx == 1,
                        isLeft: false,
                        isRight: false,
                        onTap: () {
                          setState(() {
                            btnSelectIdx = 1;
                          });
                        },
                      ),
                      topBtn(
                        title: 'این ماه',
                        selected: btnSelectIdx == 2,
                        isLeft: false,
                        isRight: false,
                        onTap: () {
                          setState(() {
                            btnSelectIdx = 2;
                          });
                        },
                      ),
                      topBtn(
                        title: 'همه',
                        selected: btnSelectIdx == 3,
                        isLeft: true,
                        isRight: false,
                        onTap: () {
                          setState(() {
                            btnSelectIdx = 3;
                          });
                          _getExpenses();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (btnSelectIdx == 0) horizontalDayList(),
              ExpenseListContent(
                expenses: state.expenses,
              ),
            ],
          );
        } else if (state is ExpenseDeleteSuccess) {
          // _getExpenses(Jalali(_jalali.year, _jalali.month, _jalali.day));
          return Container();
        } else {
          return const ExpenseListContent(
            expenses: [],
          );
        }
      }),
    );
  }

  Expanded topBtn({
    required String title,
    required bool selected,
    required bool isRight,
    required bool isLeft,
    required void Function() onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: selected
              ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: isRight
                        ? const Radius.circular(12)
                        : const Radius.circular(0),
                    topRight: isRight
                        ? const Radius.circular(12)
                        : const Radius.circular(0),
                    bottomLeft: isLeft
                        ? const Radius.circular(12)
                        : const Radius.circular(0),
                    topLeft: isLeft
                        ? const Radius.circular(12)
                        : const Radius.circular(0),
                  ),
                )
              : null,
          child: Text(
            title,
            style: TextStyle(color: selected ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }

  Container horizontalDayList() {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      height: 50,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: _jalali.monthLength,
        separatorBuilder: (context, index) => const SizedBox(
          width: 4,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIdx = index;
              });

              int jalali = Jalali(_jalali.year, _jalali.month, selectedIdx + 1)
                  .toDateTime()
                  .millisecondsSinceEpoch;
              _getExpenses(jalali);
            },
            child: CircleAvatar(
              backgroundColor:
                  (selectedIdx == index) ? AppColors.primary : AppColors.hint,
              foregroundColor: Colors.white,
              child: Text('${index + 1}'),
            ),
          );
        },
      ),
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
