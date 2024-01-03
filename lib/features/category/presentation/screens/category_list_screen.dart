import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/category/presentation/widgets/category_list_content.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../cubit/category_cubit.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({Key? key}) : super(key: key);

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  _getCategories() => BlocProvider.of<CategoryCubit>(context).getCategories();

  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(AppLocalizations.of(context)!.translate('categories')!),
    );
    return Scaffold(
      appBar: appBar,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, Routes.addEditCategoryRoute);
          _getCategories();
        },
        label: Text(AppLocalizations.of(context)!.translate('add_category')!),
        icon: const Icon(Icons.add),
      ),
      body: _buildBodyContent(),
    );
  }

  Widget _buildBodyContent() {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryIsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CategoryError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.msg,
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  onPressed: () {
                    BlocProvider.of<CategoryCubit>(context).getCategories();
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          );
        } else if (state is CategoryLoaded) {
          return Column(
            children: [
              CategoryListContent(
                categories: state.categories,
              ),
            ],
          );
        } else if (state is CategoryDeleteSuccess) {
          _getCategories();
          return Container();
        } else {
          return const Text('Unknown');
        }
      },
    );
  }
}
