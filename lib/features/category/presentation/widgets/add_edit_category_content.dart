import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/utils.dart';
import '../../../../features/category/presentation/cubit/category_cubit.dart';
import '../../../../shared/components/components.dart';
import '../../../../shared/domain/entities/category.dart';

class AddEditCategoryContent extends StatefulWidget {
  final Category? category;

  const AddEditCategoryContent({
    super.key,
    this.category,
  });

  @override
  State<AddEditCategoryContent> createState() => _AddEditCategoryContentState();
}

class _AddEditCategoryContentState extends State<AddEditCategoryContent> {
  final TextEditingController _controller = TextEditingController();
  String colorStr = '';
  String? parentId;

  @override
  void initState() {
    _controller.text = widget.category?.title ?? '';
    parentId = widget.category?.parentId;
    colorStr = widget.category?.color ?? '';
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                labelText: '',
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            CategoryDropdownWidget(
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
                      color:
                          colorStr.isEmpty ? Colors.white : HexColor(colorStr),
                    ),
                    height: 48,
                    child: colorStr.isEmpty == false
                        ? Center(
                            child: Text(
                              colorStr,
                              style: TextStyle(
                                color: AppColors.getOppositeColor(colorStr),
                                fontFamily: 'Roboto',
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
                    'انتخاب رنگ',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                if (_validateCategory(_controller.text) == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'لطفا عنوان را وارد کنید',
                        style: TextStyle(fontFamily: 'Vazir'),
                      ),
                    ),
                  );
                  return;
                }
                if (widget.category == null) {
                  final tmpCategory = Category(
                    id: IDGenerator.generateUUID(),
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
              child: widget.category == null ? Text('ذخیره') : Text('اپدیت'),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateCategory(String text) {
    return text.trim().isNotEmpty;
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
            const Text('رنگ مورد نظر را انتخاب کنید'),
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
  '#607D8B',
];
