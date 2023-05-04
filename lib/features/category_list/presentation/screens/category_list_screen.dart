import 'package:my_money_v3/config/routes/app_routes.dart';
import 'package:my_money_v3/core/widgets/error_widget.dart' as error_widget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../cubit/category_list_cubit.dart';
import '../widgets/category_list_content.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({Key? key}) : super(key: key);

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  _getCategories() =>
      BlocProvider.of<CategoryListCubit>(context).getCategories();

  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  Widget _buildBodyContent() {
    return BlocBuilder<CategoryListCubit, CategoryListState>(
      builder: (context, state) {
        if (state is CategoryListIsLoading) {
          return Center(
            child: SpinKitFadingCircle(
              color: AppColors.primary,
            ),
          );
        } else if (state is CategoryListError) {
          return error_widget.ErrorWidget(
            onPress: () {},
          );
        } else if (state is CategoryListLoaded) {
          return Column(
            children: [
              CategoryListContent(
                categories: state.categories,
              ),
            ],
          );
        } else if (state is CategoryListDeleteSuccess) {
          _getCategories();
          return Container();
        } else {
          return const CategoryListContent(
            categories: [],
          );
        }
      },
    );
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
}
