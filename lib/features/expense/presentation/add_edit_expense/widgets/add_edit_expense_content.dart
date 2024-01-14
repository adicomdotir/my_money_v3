import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/config/locale/app_localizations.dart';
import 'package:my_money_v3/config/routes/app_routes.dart';
import 'package:my_money_v3/core/domain/entities/expense.dart';
import 'package:my_money_v3/core/utils/date_format.dart';
import 'package:my_money_v3/core/utils/id_generator.dart';
import 'package:my_money_v3/core/utils/numeric_text_formatter.dart';
import 'package:my_money_v3/shared/category_drop_down/presentation/cubit/categories_drop_down_cubit.dart';
import 'package:my_money_v3/shared/category_drop_down/presentation/widgets/category_drop_down_widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../cubit/add_edit_expense_cubit.dart';

class AddEditExpenseContent extends StatefulWidget {
  final Expense? expense;

  const AddEditExpenseContent({
    Key? key,
    this.expense,
  }) : super(key: key);

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
      child: Column(
        children: [
          TextField(
            controller: _titleCtrl,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              labelText: AppLocalizations.of(context)!.translate('title')!,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
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
              labelText: AppLocalizations.of(context)!.translate('price')!,
            ),
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
                  AppLocalizations.of(context)!.translate('select_date')!,
                ),
              ),
              Text(
                dateFormat(
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
                    BlocProvider.of<CategoriesDropDownCubit>(context)
                        .getCategories();
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
                final expense = Expense(
                  id: idGenerator(),
                  title: _titleCtrl.text,
                  date: selectedDate!.toDateTime().millisecondsSinceEpoch,
                  categoryId: selectedCategoryId ?? '',
                  price: int.parse(_priceCtrl.text.replaceAll(',', '')),
                );
                context.read<AddEditExpenseCubit>().addExpense(expense);
              } else {
                final expense = Expense(
                  id: widget.expense!.id,
                  title: _titleCtrl.text,
                  date: selectedDate!.toDateTime().millisecondsSinceEpoch,
                  categoryId: selectedCategoryId ?? '',
                  price: int.parse(_priceCtrl.text.replaceAll(',', '')),
                );
                context.read<AddEditExpenseCubit>().editExpense(expense);
              }
            },
            child: widget.expense == null
                ? Text(AppLocalizations.of(context)!.translate('save')!)
                : Text(AppLocalizations.of(context)!.translate('update')!),
          ),
        ],
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