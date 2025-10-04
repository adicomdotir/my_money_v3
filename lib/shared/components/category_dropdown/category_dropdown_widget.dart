import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/lib.dart';

import 'category_dropdown_state.dart';

/// A category dropdown widget that uses shared components and follows
/// better architectural patterns.
class CategoryDropdownWidget extends StatefulWidget {
  final void Function(String) onSelected;
  final String value;
  final String? labelText;
  final String? hintText;
  final bool isRequired;
  final bool isError;
  final String? errorText;

  const CategoryDropdownWidget({
    required this.onSelected,
    required this.value,
    super.key,
    this.isRequired = false,
    this.isError = false,
    this.labelText,
    this.hintText,
    this.errorText,
  });

  @override
  State<CategoryDropdownWidget> createState() => _CategoryDropdownWidgetState();
}

class _CategoryDropdownWidgetState extends State<CategoryDropdownWidget> {
  String? selectedId;

  @override
  void initState() {
    super.initState();
    selectedId = widget.value;
    BlocProvider.of<CategoryDropdownCubit>(context).getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryDropdownCubit, CategoryDropdownState>(
      builder: (context, state) {
        if (state is CategoryDropdownLoading) {
          return const AppLoadingWidget(
            message: 'در حال بارگذاری دسته‌ها...',
            size: 20.0,
          );
        } else if (state is CategoryDropdownLoaded) {
          final categories = state.categories;

          return AppDropdownWidget<String>(
            value: selectedId,
            items: categories.map((category) => category.id).toList(),
            labelText: widget.labelText ?? 'دسته',
            hintText: widget.hintText ?? 'انتخاب کنید',
            isRequired: widget.isRequired,
            isError: widget.isError,
            errorText: widget.errorText,
            allowEmpty: true,
            emptyText: 'انتخاب کنید',
            emptyValue: '',
            itemBuilder: (id) {
              if (id.isEmpty) {
                return const SizedBox();
              }
              final category = categories.firstWhere(
                (cat) => cat.id == id,
                orElse: () => const CategoryModel(
                  id: '',
                  parentId: '',
                  title: '',
                  color: '',
                  iconKey: 'ic_other',
                ),
              );
              return Row(
                children: [
                  // Icon(
                  //   category.iconKey as IconData,
                  //   size: 20,
                  // ),
                  // const SizedBox(width: 8),
                  Expanded(child: Text(category.title)),
                ],
              );
            },
            itemToString: (id) {
              if (id.isEmpty) {
                return '';
              }
              final category = categories.firstWhere(
                (cat) => cat.id == id,
                orElse: () => const CategoryModel(
                  id: '',
                  parentId: '',
                  title: '',
                  color: '',
                  iconKey: 'ic_other',
                ),
              );
              return category.title;
            },
            onChanged: (String? newValue) {
              setState(() {
                selectedId = newValue ?? '';
              });
              widget.onSelected(newValue ?? '');
            },
          );
        } else if (state is CategoryDropdownError) {
          return Column(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                'خطا در بارگذاری دسته‌ها',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<CategoryDropdownCubit>(context)
                      .getCategories();
                },
                child: const Text('تلاش مجدد'),
              ),
            ],
          );
        }

        return const Text('وضعیت نامشخص');
      },
    );
  }
}
