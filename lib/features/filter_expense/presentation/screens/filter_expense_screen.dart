import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/bloc/global_bloc.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/domain/entities/expense.dart';
import '../bloc/filter_expnese_bloc.dart';

class FilterExpenseScreen extends StatefulWidget {
  const FilterExpenseScreen({
    required this.id,
    required this.fromDate,
    super.key,
  });

  final String id;
  final String? fromDate;

  @override
  State<FilterExpenseScreen> createState() => _FilterExpenseScreenState();
}

class _FilterExpenseScreenState extends State<FilterExpenseScreen> {
  @override
  void initState() {
    BlocProvider.of<FilterExpneseBloc>(context)
        .add(GetFilterExpenseEvent(widget.id, widget.fromDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.filter_alt, size: 24),
          SizedBox(width: 8),
          Text('هزینه‌های فیلترشده'),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
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

  Widget _buildBodyContent() {
    return BlocConsumer<FilterExpneseBloc, FilterExpenseState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is FilterExpenseLoading) {
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
        } else if (state is FilterExpenseLoaded) {
          return _showListView(state.expenses);
        } else if (state is FilterExpenseError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'خطا در بارگذاری',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  state.message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    BlocProvider.of<FilterExpneseBloc>(context)
                        .add(GetFilterExpenseEvent(widget.id, widget.fromDate));
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('تلاش مجدد'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.help_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'وضعیت نامشخص',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _showListView(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'هزینه‌ای یافت نشد',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'در این دسته‌بندی هزینه‌ای ثبت نشده است',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    final unit = context.read<GlobalBloc>().state.settings.unit;
    final categoryTitle = expenses.first.category?.title ?? 'نامشخص';
    final categoryColor = expenses.first.category?.color ?? '#000000';
    final totalAmount =
        expenses.fold<int>(0, (sum, expense) => sum + expense.price);

    return Column(
      children: [
        // هدر اطلاعات
        Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                HexColor(categoryColor).withOpacity(0.2),
                HexColor(categoryColor).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: HexColor(categoryColor).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // آیکون دسته‌بندی
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: HexColor(categoryColor),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.category,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),

              // اطلاعات
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${expenses.length} هزینه',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'مجموع: ${formatPrice(totalAmount, unit)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('تعداد', '${expenses.length}', Icons.list),
              _buildStatItem(
                'میانگین',
                formatPrice(totalAmount ~/ expenses.length, unit),
                Icons.trending_up,
              ),
              _buildStatItem(
                'بیشترین',
                formatPrice(_getMaxExpense(expenses), unit),
                Icons.arrow_upward,
              ),
            ],
          ),
        ),

        // لیست هزینه‌ها
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: ListView.separated(
              itemCount: expenses.length,
              separatorBuilder: (context, index) => SizedBox(height: 8),
              itemBuilder: (context, index) {
                return _buildExpenseCard(expenses[index], unit);
              },
            ),
          ),
        ),
      ],
    );
  }

  // تابع کمکی
  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  int _getMaxExpense(List<Expense> expenses) {
    return expenses.fold<int>(
        0, (max, expense) => expense.price > max ? expense.price : max);
  }

  Widget _buildExpenseCard(Expense expense, int unit) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // دایره رنگی
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: HexColor(expense.category?.color ?? '#000000'),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 16),

            // اطلاعات اصلی
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    formatDate(expense.date),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // مبلغ
            Text(
              formatPrice(expense.price, unit),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
