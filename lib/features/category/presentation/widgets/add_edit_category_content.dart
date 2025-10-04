import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/utils.dart';
import '../../../../features/category/presentation/cubit/category_cubit.dart';
import '../../../../shared/components/components.dart';
import '../../../../shared/domain/entities/category.dart';
import '../../../../shared/utils/icon_catalog.dart';

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
  IconData iconKey = IconCatalog.defaultIconKey;

  @override
  void initState() {
    _controller.text = widget.category?.title ?? '';
    parentId = widget.category?.parentId;
    colorStr = widget.category?.color ?? '';
    iconKey =
        widget.category?.iconKey as IconData? ?? IconCatalog.defaultIconKey;
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
                labelText: 'عنوان',
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
                Icon(
                  iconKey,
                  size: 24,
                ),
                const SizedBox(width: 12),
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
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () async {
                    final picked = await iconDialog(context, initial: iconKey);
                    if (picked != null) {
                      setState(() {
                        iconKey = picked;
                      });
                    }
                  },
                  child: const Text('انتخاب آیکون'),
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
                    iconKey: iconKey.toString(),
                  );
                  context.read<CategoryCubit>().addCategory(tmpCategory);
                } else {
                  final tmpCategory = Category(
                    id: widget.category!.id,
                    parentId: parentId ?? '',
                    title: _controller.text,
                    color: colorStr,
                    iconKey: iconKey.toString(),
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

Future<IconData?> iconDialog(BuildContext context, {IconData? initial}) {
  return showDialog<IconData>(
    context: context,
    builder: (_) {
      String query = '';
      final keys = IconCatalog.allIcons;
      return StatefulBuilder(
        builder: (context, setState) {
          final filtered = keys
              .where(
                (k) => k.toString().toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('آیکون مورد نظر را انتخاب کنید'),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(hintText: 'جستجو...'),
                  onChanged: (v) => setState(() => query = v),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 300,
                  width: 260,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, index) {
                      final key = filtered[index];
                      return GestureDetector(
                        onTap: () => Navigator.of(context).pop(key),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(key),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
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
