import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../../../../config/routes/app_routes.dart';
import '../../../../../core/bloc/global_bloc.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/category_drop_down/presentation/cubit/categories_drop_down_cubit.dart';
import '../../../../../shared/category_drop_down/presentation/widgets/category_drop_down_widget.dart';
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
      _titleCtrl.text = widget.expense!.title;
      _priceCtrl.text = widget.expense!.price.toString();
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
              ),
            ),
            const SizedBox(
              height: 16,
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
                      NumericOnlyFormatter(),
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
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text(
                    'انتخاب تاریخ',
                  ),
                ),
                Text(
                  formatDate(
                    selectedDate?.toDateTime().millisecondsSinceEpoch ??
                        DateTime.now().millisecondsSinceEpoch,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: CategoryDropDownWidget(
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
                        BlocProvider.of<CategoriesDropDownCubit>(context)
                            .getCategories();
                      }
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                if (_validateExpense() == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'لطفا عنوان و قیمت و دسته را وارد کنید',
                        style: TextStyle(fontFamily: 'Vazir'),
                      ),
                    ),
                  );
                  return;
                }
                if (widget.expense == null) {
                  int newPrice = int.parse(_priceCtrl.text.replaceAll(',', ''));
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
                  int newPrice = int.parse(_priceCtrl.text.replaceAll(',', ''));
                  if (BlocProvider.of<GlobalBloc>(context)
                          .state
                          .settings
                          .unit ==
                      1) {
                    newPrice = (newPrice / 10) as int;
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
              child: widget.expense == null ? Text('ذخیره') : Text('ویرایش'),
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
