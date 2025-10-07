import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/routes/app_routes.dart';
import '../../../../../core/bloc/global_bloc.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/domain/entities/expense.dart';
import '../../../../../shared/widgets/confirm_dialog.dart';
import '../../../../expense/presentation/expense_list/cubit/expense_cubit.dart';

class ExpenseListContent extends StatefulWidget {
  final List<Expense> expenses;

  const ExpenseListContent({
    required this.expenses,
    super.key,
  });

  @override
  State<ExpenseListContent> createState() => _ExpenseListContentState();
}

class _ExpenseListContentState extends State<ExpenseListContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(16),
        child: widget.expenses.isEmpty
            ? Center(
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
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : ListView.separated(
                itemCount: widget.expenses.length,
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return ExpenseCard(
                    expense: widget.expenses[index],
                  );
                },
              ),
      ),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard({
    required this.expense,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.addEditExpanseRoute,
              arguments: {
                'expense': Expense(
                  id: expense.id,
                  title: expense.title,
                  price: expense.price,
                  date: expense.date,
                  categoryId: expense.categoryId,
                ),
              },
            ).then((value) {
              if (context.mounted) {
                BlocProvider.of<ExpenseCubit>(context).getExpenses();
              }
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(16),
            height: 100,
            child: Row(
              children: [
                // نوار رنگی دسته‌بندی
                Container(
                  width: 6,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: HexColor(expense.category!.color),
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(8),
                    ),
                  ),
                ),
                SizedBox(width: 16),

                // آیکون دسته‌بندی
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: HexColor(expense.category!.color).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.receipt,
                    color: HexColor(expense.category!.color),
                    size: 20,
                  ),
                ),
                SizedBox(width: 16),

                // اطلاعات اصلی
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // عنوان و مبلغ
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              expense.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            formatPrice(
                              expense.price,
                              context.read<GlobalBloc>().state.settings.unit,
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),

                      // اطلاعات فرعی
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // دسته‌بندی
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: HexColor(expense.category!.color)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: HexColor(expense.category!.color),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  expense.category!.title,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // تاریخ
                          Text(
                            formatDate(expense.date),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // دکمه حذف
                IconButton(
                  onPressed: () async {
                    await showDeleteDialog(context).then((value) {
                      if (context.mounted && value != null && value) {
                        BlocProvider.of<ExpenseCubit>(context)
                            .deleteExpense(expense.id);
                      }
                    });
                  },
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                  padding: EdgeInsets.all(4),
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // نسخه فشرده برای نمایش بیشتر
  Widget _buildCompactExpenseCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            // منطق ویرایش
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                // دایره رنگی کوچک
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: HexColor(expense.category!.color),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12),

                // عنوان
                Expanded(
                  child: Text(
                    expense.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // مبلغ
                Text(
                  formatPrice(
                    expense.price,
                    context.read<GlobalBloc>().state.settings.unit,
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[600],
                  ),
                ),

                // دکمه حذف
                IconButton(
                  onPressed: () {
                    // منطق حذف
                  },
                  icon: Icon(Icons.delete_outline, size: 18, color: Colors.red),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
