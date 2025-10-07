import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/core/bloc/global_bloc.dart';
import 'package:my_money_v3/core/utils/formatting/date_formatter.dart';
import 'package:my_money_v3/core/utils/formatting/price_formatter.dart';
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(height: 16),
                Text(
                  'در حال بارگذاری هزینه‌ها...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        } else if (state.error != null) {
          return AppErrorWidget(
            onPress: () {
              BlocProvider.of<ExpenseCubit>(context)
                  .changeCalenderFilterType(0);
            },
          );
        } else if (state.expenses?.isEmpty == true) {
          return Column(
            children: [
              CalenderFilterWidget(),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'هزینه‌ای برای نمایش وجود ندارد',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'در این بازه زمانی هزینه‌ای ثبت نشده است',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              CalenderFilterWidget(),
              // نمایش خلاصه آماری
              _buildSummaryCard(context, state),
              Expanded(
                child: ExpenseListContent(
                  expenses: state.expenses ?? [],
                ),
              ),
            ],
          );
        }
      },
    );
  }

// کارت خلاصه آماری
  Widget _buildSummaryCard(BuildContext context, ExpenseState state) {
    final total =
        state.expenses?.fold<int>(0, (sum, expense) => sum + expense.price) ??
            0;
    final count = state.expenses?.length ?? 0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(
            context,
            'تعداد',
            '$count',
            Icons.list,
          ),
          _buildSummaryItem(
            context,
            'مجموع',
            formatPrice(total, context.read<GlobalBloc>().state.settings.unit),
            Icons.attach_money,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Row(
        children: [
          Text('📋 لیست هزینه‌ها'),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
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

        return Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // بخش انتخاب نوع فیلتر
              _buildFilterTypeSelector(context, calenderFilterType),
              // بخش انتخاب تاریخ
              _buildDateSelector(context, state, calenderFilterType),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterTypeSelector(
    BuildContext context,
    int calenderFilterType,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterTypeItem(context, 'روز', 0, calenderFilterType),
          _buildFilterTypeItem(context, 'هفته', 1, calenderFilterType),
          _buildFilterTypeItem(context, 'ماه', 2, calenderFilterType),
        ],
      ),
    );
  }

  Widget _buildFilterTypeItem(
    BuildContext context,
    String text,
    int index,
    int currentIndex,
  ) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<ExpenseCubit>(context).changeCalenderFilterType(index);
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: currentIndex == index
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: currentIndex == index
                ? Colors.white
                : Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    ExpenseState state,
    int calenderFilterType,
  ) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // دکمه بعدی
          _buildDateNavButton(
            context,
            Icons.chevron_left,
            () => _navigateDate(context, state, calenderFilterType, 1),
          ),

          // نمایش تاریخ
          Expanded(
            child: Center(
              child: _buildDateDisplay(context, state, calenderFilterType),
            ),
          ),

          // دکمه قبلی
          _buildDateNavButton(
            context,
            Icons.chevron_right,
            () => _navigateDate(context, state, calenderFilterType, -1),
          ),
        ],
      ),
    );
  }

  Widget _buildDateNavButton(
    BuildContext context,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onTap,
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildDateDisplay(
    BuildContext context,
    ExpenseState state,
    int filterType,
  ) {
    switch (filterType) {
      case 0: // روز
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${state.fromDate?.day ?? ''} ${getPersianMonthName((state.fromDate?.month ?? 1) - 1)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Text(
              '${state.fromDate?.year ?? ''}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        );
      case 1: // هفته
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${state.fromDate?.formatShortMonthDay()} تا ${state.fromDate?.addDays(6).formatShortMonthDay()}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Text(
              'هفته جاری',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        );
      case 2: // ماه
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              getPersianMonthName((state.fromDate?.month ?? 1) - 1),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Text(
              '${state.fromDate?.year ?? ''}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        );
      default:
        return SizedBox();
    }
  }

  void _navigateDate(
    BuildContext context,
    ExpenseState state,
    int filterType,
    int direction,
  ) {
    final cubit = BlocProvider.of<ExpenseCubit>(context);
    Jalali? newDate = state.fromDate ?? Jalali.now();

    switch (filterType) {
      case 0: // روز
        newDate = newDate.addDays(direction);
        break;
      case 1: // هفته
        newDate = newDate.addDays(7 * direction);
        break;
      case 2: // ماه
        newDate = newDate.addMonths(direction);
        newDate = Jalali(newDate.year, newDate.month, 1);
        break;
    }

    cubit.changeFromDate(newDate);
  }
}
