import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/domain/entities/category.dart';
import '../cubit/categories_drop_down_cubit.dart';
import '../../../../injection_container.dart' as di;

class CategoriesDropDownWidget extends StatefulWidget {
  final void Function(Category) onSelected;

  const CategoriesDropDownWidget({
    super.key,
    required this.onSelected,
  });

  @override
  State<CategoriesDropDownWidget> createState() => _CategoriesDropDownState();
}

class _CategoriesDropDownState extends State<CategoriesDropDownWidget> {
  Category? selectedCategory;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<CategoriesDropDownCubit>()..getCategories(),
      child: BlocBuilder<CategoriesDropDownCubit, CategoriesDropDownState>(
        builder: (context, state) {
          if (state is CategoriesDropDownLoading) {
            return const CircularProgressIndicator();
          } else if (state is CategoriesDropDownLoaded) {
            return InputDecorator(
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context)!.translate('parent_category')!,
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
                  value: selectedCategory,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (Category? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                    widget.onSelected(newValue!);
                  },
                  items: state.categories.map<DropdownMenuItem<Category>>(
                    (Category value) {
                      return DropdownMenuItem<Category>(
                        value: value,
                        child: Text(value.title),
                      );
                    },
                  ).toList(),
                ),
              ),
            );
          }
          return const Text('Unknown');
        },
      ),
    );
  }
}
