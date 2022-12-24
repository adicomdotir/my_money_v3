import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/config/locale/app_localizations.dart';
import 'package:my_money_v3/core/utils/id_generator.dart';
import 'package:my_money_v3/features/add_edit_category/domain/entities/category.dart';
import 'package:my_money_v3/features/add_edit_category/presentation/cubit/add_edit_category_cubit.dart';

class AddEditCategoryContent extends StatefulWidget {
  Category? category;
  List<Category> categories;

  AddEditCategoryContent({
    Key? key,
    this.category,
    required this.categories,
  }) : super(key: key);

  @override
  State<AddEditCategoryContent> createState() => _AddEditCategoryContentState();
}

class _AddEditCategoryContentState extends State<AddEditCategoryContent> {
  final TextEditingController _controller = TextEditingController();
  Category _parentCategory = const Category(
    id: '-1',
    parentId: '-1',
    title: 'Empty',
    color: 'color',
  );
  List<Category> categories = [];

  @override
  void initState() {
    categories.add(_parentCategory);
    categories.addAll(widget.categories);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                      items: categories.map<DropdownMenuItem<Category>>(
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
              String parentId = _parentCategory.id;
              widget.category = Category(
                id: idGenerator(),
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
