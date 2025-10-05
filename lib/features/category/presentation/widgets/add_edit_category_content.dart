import 'dart:math';

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
    Random random = Random();
    colorStr = appColorList[random.nextInt(appColorList.length)];
    colorStr = widget.category?.color ?? colorStr;
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
                labelText: 'عنوان دسته‌بندی',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              ),
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 24,
            ),
            CategoryDropdownWidget(
              value: widget.category?.parentId ?? '',
              onSelected: (selectedValue) {
                parentId = selectedValue;
              },
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: colorStr.isEmpty
                          ? Colors.grey[200]
                          : HexColor(colorStr),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    height: 56,
                    child: Center(
                      child: colorStr.isEmpty
                          ? Text(
                              'رنگی انتخاب نشده',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: HexColor(colorStr),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          AppColors.getOppositeColor(colorStr),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'رنگ انتخاب شده',
                                  style: TextStyle(
                                    color: AppColors.getOppositeColor(colorStr),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await colorDialog(context);
                      if (result != null) {
                        setState(() {
                          colorStr = result;
                        });
                      }
                    },
                    icon: Icon(Icons.color_lens),
                    label: Text('انتخاب رنگ'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  if (_validateCategory(_controller.text) == false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.warning_amber, color: Colors.white),
                            SizedBox(width: 8),
                            Text('لطفا عنوان دسته‌بندی را وارد کنید'),
                          ],
                        ),
                        backgroundColor: Colors.red[600],
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  // منطق ذخیره‌سازی
                  if (widget.category == null) {
                    final tmpCategory = Category(
                      id: IDGenerator.generateUUID(),
                      parentId: parentId ?? '',
                      title: _controller.text,
                      color: colorStr,
                      iconKey: '',
                    );
                    context.read<CategoryCubit>().addCategory(tmpCategory);
                  } else {
                    final tmpCategory = Category(
                      id: widget.category!.id,
                      parentId: parentId ?? '',
                      title: _controller.text,
                      color: colorStr,
                      iconKey: '',
                    );
                    context.read<CategoryCubit>().editCategory(tmpCategory);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  widget.category == null
                      ? '🎯 ذخیره دسته‌بندی'
                      : '✏️ به‌روزرسانی',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
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
        title: Row(
          children: [
            Icon(Icons.palette, color: Theme.of(context).primaryColor),
            SizedBox(width: 8),
            Text('انتخاب رنگ دسته‌بندی'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'رنگ مورد نظر برای دسته‌بندی را انتخاب کنید',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 300,
              width: 280,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(appColorList[index]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor(appColorList[index]),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: AppColors.getOppositeColor(appColorList[index]),
                        size: 20,
                      ),
                    ),
                  ),
                ),
                itemCount: appColorList.length,
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
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
  // Additional colors
  '#FF1744',
  '#C51162',
  '#AA00FF',
  '#6200EA',
  '#304FFE',
  '#2962FF',
  '#0091EA',
  '#00B8D4',
  '#00C853',
  '#64DD17',
  '#AEEA00',
  '#FFD600',
  '#FFAB00',
  '#FF6D00',
  '#DD2C00',
  '#3E2723',
  '#212121',
  '#263238',
  '#37474F',
  '#546E7A',
  '#78909C',
  '#90A4AE',
  '#B0BEC5',
  '#ECEFF1',
  '#FAFAFA',
];
