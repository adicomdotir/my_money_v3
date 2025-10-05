import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/utils.dart';
import '../../../../features/category/presentation/cubit/category_cubit.dart';
import '../../../../shared/domain/entities/category.dart';
import '../../../../shared/widgets/confirm_dialog.dart';

class CategoryListContent extends StatefulWidget {
  final List<Category> categories;

  const CategoryListContent({
    required this.categories,
    super.key,
  });

  @override
  State<CategoryListContent> createState() => _CategoryListContentState();
}

class _CategoryListContentState extends State<CategoryListContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: // در CategoryListContent جایگزین ListView.builder کن:
            widget.categories.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'هنوز دسته‌بندیی ایجاد نکرده‌اید',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'برای شروع روی دکمه "+" پایین صفحه کلیک کنید',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemCount: widget.categories.length,
                    itemBuilder: (context, index) {
                      return CategoryCard(category: widget.categories[index]);
                    },
                  ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.addEditCategoryRoute,
              arguments: {'category': category},
            ).whenComplete(() {
              if (context.mounted) {
                BlocProvider.of<CategoryCubit>(context).getCategories();
              }
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // دایره رنگی بزرگ‌تر
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: HexColor(category.color),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: HexColor(category.color).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),

                // عنوان دسته‌بندی
                Expanded(
                  child: Text(
                    category.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // دکمه‌های اکشن
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // دکمه ویرایش
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          Routes.addEditCategoryRoute,
                          arguments: {'category': category},
                        );
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blue,
                        size: 20,
                      ),
                      padding: EdgeInsets.all(4),
                      constraints: BoxConstraints(),
                    ),

                    // دکمه حذف
                    IconButton(
                      onPressed: () async {
                        await showDeleteDialog(context).then((value) {
                          if (context.mounted && value != null && value) {
                            BlocProvider.of<CategoryCubit>(context)
                                .deleteCategory(category.id);
                          }
                        });
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                      padding: EdgeInsets.all(4),
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Future<bool?> showDeleteDialog(BuildContext context) {
//   return showDialog<bool>(
//     context: context,
//     builder: (context) => ConfirmDialog(
//       title: 'حذف دسته‌بندی',
//       message: 'آیا از حذف این دسته‌بندی اطمینان دارید؟',
//       confirmText: 'حذف',
//       cancelText: 'انصراف',
//       confirmColor: Colors.red,
//       icon: Icon(
//         Icons.warning_rounded,
//         color: Colors.orange,
//         size: 48,
//       ),
//     ),
//   );
// }
