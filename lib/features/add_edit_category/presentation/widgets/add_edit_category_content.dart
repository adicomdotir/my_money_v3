import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/config/locale/app_localizations.dart';
import 'package:my_money_v3/features/add_edit_category/domain/entities/category.dart';
import 'package:my_money_v3/features/add_edit_category/presentation/cubit/add_edit_category_cubit.dart';

List<Category> categoryList = [
  Category(id: -1, parentId: -1, title: 'Empty', color: 'color'),
  Category(id: 1, parentId: -1, title: 'title1', color: 'color'),
  Category(id: 2, parentId: -1, title: 'title2', color: 'color'),
];

class AddEditCategoryContent extends StatefulWidget {
  Category? category;

  AddEditCategoryContent({Key? key, this.category}) : super(key: key);

  @override
  State<AddEditCategoryContent> createState() => _AddEditCategoryContentState();
}

class _AddEditCategoryContentState extends State<AddEditCategoryContent> {
  final TextEditingController _controller = TextEditingController();
  Category _parentCategory =
      Category(id: -1, parentId: -1, title: 'Empty', color: 'color');

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: _controller,
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
          Row(
            children: [
              Expanded(
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .translate('parent_category')!,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 0.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Category>(
                      value: _parentCategory,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (Category? newValue) {
                        _parentCategory = newValue!;
                        setState(() {});
                      },
                      items: categoryList.map<DropdownMenuItem<Category>>(
                        (Category value) {
                          return DropdownMenuItem<Category>(
                            value: value,
                            child: Text(value.title),
                          );
                        },
                      ).toList(),
                    ),
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
              int parentId = _parentCategory.id;
              widget.category = Category(
                id: 0,
                parentId: parentId,
                title: _controller.text,
                color: '',
              );
              context
                  .read<AddEditCategoryCubit>()
                  .addCategory(widget.category!);
            },
            child: Text(AppLocalizations.of(context)!.translate('save')!),
          )
        ],
      ),
    );
  }
}
