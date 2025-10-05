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
            // در AppDropdownWidget این استایل‌ها رو داشته باشه:
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            value: selectedId,
            items: categories.map((category) => category.id).toList(),
            labelText: widget.labelText ?? 'دسته‌بندی',
            hintText: widget.hintText ?? 'انتخاب کنید',
            isRequired: widget.isRequired,
            isError: widget.isError,
            errorText: widget.errorText,
            allowEmpty: true,
            emptyText: 'انتخاب کنید',
            emptyValue: '',
            itemBuilder: (id) {
              if (id.isEmpty) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'انتخاب کنید',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                );
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

              return Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: HexColor(category.color),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        category.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
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
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red,
                  size: 32,
                ),
                SizedBox(height: 8),
                Text(
                  'خطا در بارگذاری دسته‌ها',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    BlocProvider.of<CategoryDropdownCubit>(context)
                        .getCategories();
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('تلاش مجدد'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          );
        }

        return const Text('وضعیت نامشخص');
      },
    );
  }
}
