import 'package:flutter/material.dart';
import 'package:my_money_v3/config/locale/app_localizations.dart';
import 'package:my_money_v3/features/add_edit_expanse/domain/entities/expense.dart';

import '../../../../core/utils/app_colors.dart';

class AddEditExpenseContent extends StatelessWidget {
  final Expense? expense;

  const AddEditExpenseContent({Key? key, this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
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
            keyboardType: TextInputType.number,
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
                onPressed: () {},
                child: Text(
                  AppLocalizations.of(context)!.translate('select_date')!,
                ),
              ),
              const Text(
                '0000',
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.translate('category')!,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 0.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: 'One',
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (String? newValue) {},
                      items: ['One', 'Two']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primary,
                ),
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(AppLocalizations.of(context)!.translate('save')!),
          )
        ],
      ),
    );
  }
}
