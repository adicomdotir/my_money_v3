import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/config/locale/app_localizations.dart';
import 'package:my_money_v3/config/routes/app_routes.dart';
import 'package:my_money_v3/core/utils/hex_color.dart';
import 'package:my_money_v3/features/category/presentation/cubit/category_cubit.dart';

import '../../../../shared/domain/entities/category.dart';

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
        child: ListView.builder(
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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.addEditCategoryRoute,
          arguments: {'category': category},
        ).whenComplete(() {
          BlocProvider.of<CategoryCubit>(context).getCategories();
        });
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          color: HexColor(category.color),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(category.title),
                      ],
                    ),
                    IconButton(
                      onPressed: () async {
                        await showDeleteDialog(context).then((value) {
                          if (value != null && value) {
                            BlocProvider.of<CategoryCubit>(context)
                                .deleteCategory(category.id);
                          }
                        });
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool?> showDeleteDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        content:
            Text(AppLocalizations.of(context)!.translate('delete_question')!),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(AppLocalizations.of(context)!.translate('yes')!),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(AppLocalizations.of(context)!.translate('no')!),
          ),
        ],
      );
    },
  );
}
