import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/domain/entities/category.dart';
import '../cubit/categories_drop_down_cubit.dart';
import '../../../../injection_container.dart' as di;

class CategoriesDropDownWidget extends StatefulWidget {
  final void Function(String) onSelected;
  final String value;

  const CategoriesDropDownWidget({
    super.key,
    required this.onSelected,
    required this.value,
  });

  @override
  State<CategoriesDropDownWidget> createState() => _CategoriesDropDownState();
}

class _CategoriesDropDownState extends State<CategoriesDropDownWidget> {
  String? selectedId;

  @override
  void initState() {
    selectedId = widget.value;
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
      ),
    );
  }
}
