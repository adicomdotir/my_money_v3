import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/config/locale/app_localizations.dart';
import 'package:my_money_v3/core/utils/hex_color.dart';
import 'package:my_money_v3/core/utils/id_generator.dart';
import 'package:my_money_v3/core/domain/entities/category.dart';
import 'package:my_money_v3/core/utils/opposite_color.dart';
import 'package:my_money_v3/features/category/presentation/cubit/category_cubit.dart';
import 'package:my_money_v3/shared/category_drop_down/presentation/widgets/category_drop_down_widget.dart';

class AddEditCategoryContent extends StatefulWidget {
  final Category? category;

  const AddEditCategoryContent({
    Key? key,
    this.category,
  }) : super(key: key);

  @override
  State<AddEditCategoryContent> createState() => _AddEditCategoryContentState();
}

class _AddEditCategoryContentState extends State<AddEditCategoryContent> {
  final TextEditingController _controller = TextEditingController();
  String colorStr = '';
  String? parentId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.category?.title ?? '';
    debugPrint(widget.category?.parentId);
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
          CategoriesDropDownWidget(
            value: widget.category?.parentId ?? '',
            onSelected: (selectedValue) {
              parentId = selectedValue;
            },
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: colorStr.isEmpty ? Colors.white : HexColor(colorStr),
                  ),
                  height: 48,
                  child: colorStr.isEmpty == false
                      ? Center(
                          child: Text(
                            colorStr,
                            style: TextStyle(
                              color: generateOppositeColor(colorStr),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              TextButton(
                onPressed: () async {
                  final result = await colorDialog(context);
                  if (result != null) {
                    setState(() {
                      colorStr = result;
                    });
                  }
                },
                child: const Text(
                  'Select Color',
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () {
              if (widget.category == null) {
                final tmpCategory = Category(
                  id: idGenerator(),
                  parentId: parentId ?? '',
                  title: _controller.text,
                  color: colorStr,
                );
                context.read<CategoryCubit>().addCategory(tmpCategory);
              } else {
                final tmpCategory = Category(
                  id: widget.category!.id,
                  parentId: parentId ?? '',
                  title: _controller.text,
                  color: colorStr,
                );
                context.read<CategoryCubit>().editCategory(tmpCategory);
              }
            },
            child: widget.category == null
                ? Text(AppLocalizations.of(context)!.translate('save')!)
                : Text(AppLocalizations.of(context)!.translate('update')!),
          )
        ],
      ),
    );
  }
}

Future<String?> colorDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.translate('delete_question')!),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 250,
              width: 200,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(appColorList[index]);
                  },
                  child: Container(
                    color: HexColor(appColorList[index]),
                  ),
                ),
                itemCount: appColorList.length,
              ),
            ),
          ],
        ),
      );
    },
  );
}

const appColorList = [
  '#F44336',
  '#E91E63',
  '#9C27B0',
  '#673AB7',
  '#3F51B5',
  '#2196F3',
  '#03A9F4',
  '#00BCD4',
  '#009688',
  '#4CAF50',
  '#8BC34A',
  '#CDDC39',
  '#FFEB3B',
  '#FFC107',
  '#FF9800',
  '#FF5722',
  '#795548',
  '#9E9E9E',
];
