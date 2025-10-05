import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/shared/components/components.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../../../config/routes/app_routes.dart';
import '../../../../../core/bloc/global_bloc.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/domain/entities/expense.dart';
import '../cubit/add_edit_expense_cubit.dart';

class AddEditExpenseContent extends StatefulWidget {
  final Expense? expense;

  const AddEditExpenseContent({
    super.key,
    this.expense,
  });

  @override
  State<AddEditExpenseContent> createState() => _AddEditExpenseContentState();
}

class _AddEditExpenseContentState extends State<AddEditExpenseContent> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  String? selectedCategoryId;
  Jalali? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = Jalali.now();
    if (widget.expense != null) {
      int newPrice = widget.expense!.price;
      if (BlocProvider.of<GlobalBloc>(context).state.settings.unit == 1) {
        newPrice = newPrice * 10;
      }
      _titleCtrl.text = widget.expense!.title;
      _priceCtrl.text = addThousandsSeparator(newPrice.toString());
      selectedCategoryId = widget.expense!.categoryId;
      selectedDate = Jalali.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(widget.expense!.date),
      );
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                labelText: 'عنوان',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ), // افزایش padding
              ),
              style: TextStyle(fontSize: 16), // افزایش سایز فونت
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                  flex: 17,
                  child: TextField(
                    controller: _priceCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      NumericTextFormatter(),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      labelText: 'قیمت',
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      getCurrencyUnit(
                        context.read<GlobalBloc>().state.settings.unit,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () => _selectDate(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 18),
                        SizedBox(width: 8),
                        Text('انتخاب تاریخ'),
                      ],
                    ),
                  ),
                ),
                Text(
                  formatDate(
                    selectedDate?.toDateTime().millisecondsSinceEpoch ??
                        DateTime.now().millisecondsSinceEpoch,
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                  child: CategoryDropdownWidget(
                    onSelected: (newValue) {
                      setState(() {
                        selectedCategoryId = newValue;
                      });
                    },
                    value: selectedCategoryId ?? '',
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(Routes.addEditCategoryRoute)
                        .then((value) {
                      if (context.mounted) {
                        BlocProvider.of<CategoryDropdownCubit>(context)
                            .getCategories();
                      }
                    });
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  if (_validateExpense() == false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'لطفا عنوان، قیمت و دسته‌بندی را وارد کنید',
                          style: TextStyle(
                            fontFamily: 'Vazir',
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.red[600], // ✅ قرمز پررنگ
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        action: SnackBarAction(
                          label: 'متوجه شدم',
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    );
                  }
                  if (widget.expense == null) {
                    int newPrice =
                        int.parse(_priceCtrl.text.replaceAll(',', ''));
                    if (BlocProvider.of<GlobalBloc>(context)
                            .state
                            .settings
                            .unit ==
                        1) {
                      newPrice = newPrice ~/ 10;
                    }
                    final expense = Expense(
                      id: IDGenerator.generateUUID(),
                      title: _titleCtrl.text,
                      date: selectedDate!.toDateTime().millisecondsSinceEpoch,
                      categoryId: selectedCategoryId ?? '',
                      price: newPrice,
                    );
                    context.read<AddEditExpenseCubit>().addExpense(expense);
                  } else {
                    int newPrice =
                        int.parse(_priceCtrl.text.replaceAll(',', ''));
                    if (BlocProvider.of<GlobalBloc>(context)
                            .state
                            .settings
                            .unit ==
                        1) {
                      newPrice = (newPrice / 10).toInt();
                    }
                    final expense = Expense(
                      id: widget.expense!.id,
                      title: _titleCtrl.text,
                      date: selectedDate!.toDateTime().millisecondsSinceEpoch,
                      categoryId: selectedCategoryId ?? '',
                      price: newPrice,
                    );
                    context.read<AddEditExpenseCubit>().editExpense(expense);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  widget.expense == null ? '💾 ذخیره هزینه' : '✏️ ویرایش هزینه',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    Jalali? selected = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.fromDateTime(DateTime.now()),
      firstDate: Jalali(1370, 1),
      lastDate: Jalali(1450, 1),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }

  bool _validateExpense() {
    if (_titleCtrl.text.trim().isEmpty) {
      return false;
    }

    if (_priceCtrl.text.trim().isEmpty) {
      return false;
    }

    if (selectedCategoryId == null || selectedCategoryId!.trim().isEmpty) {
      return false;
    }

    return true;
  }
}
