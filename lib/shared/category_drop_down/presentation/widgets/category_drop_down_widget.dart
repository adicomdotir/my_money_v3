import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/category.dart';
import '../cubit/categories_drop_down_cubit.dart';

class CategoryDropDownWidget extends StatefulWidget {
  final void Function(String) onSelected;
  final String value;

  const CategoryDropDownWidget({
    required this.onSelected,
    required this.value,
    super.key,
  });

  @override
  State<CategoryDropDownWidget> createState() => _CategoriesDropDownState();
}

class _CategoriesDropDownState extends State<CategoryDropDownWidget> {
  String? selectedId;

  @override
  void initState() {
    selectedId = widget.value;
    BlocProvider.of<CategoriesDropDownCubit>(context).getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesDropDownCubit, CategoriesDropDownState>(
      builder: (context, state) {
        if (state is CategoriesDropDownLoading) {
          return const CircularProgressIndicator();
        } else if (state is CategoriesDropDownLoaded) {
          final dropDownList = state.categories.map<DropdownMenuItem<String>>(
            (Category value) {
              return DropdownMenuItem<String>(
                value: value.id,
                child: Text(value.title),
              );
            },
          ).toList();
          dropDownList.insert(
            0,
            const DropdownMenuItem(
              value: '',
              child: Text(
                'انتخاب کنید',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
          return InputDecorator(
            decoration: InputDecoration(
              labelText: 'دسته',
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
                value: selectedId,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedId = newValue;
                  });
                  widget.onSelected(newValue!);
                },
                items: dropDownList,
              ),
            ),
          );
        }
        return const Text('Unknown');
      },
    );
  }
}
