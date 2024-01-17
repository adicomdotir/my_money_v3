import 'package:my_money_v3/shared/domain/entities/category.dart';
import 'package:my_money_v3/core/widgets/error_widget.dart' as error_widget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/category/presentation/cubit/category_cubit.dart';
import 'package:my_money_v3/features/category/presentation/widgets/add_edit_category_content.dart';

import '../../../../config/locale/app_localizations.dart';

class AddEditCategoryScreen extends StatefulWidget {
  const AddEditCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddEditCategoryScreen> createState() => _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends State<AddEditCategoryScreen> {
  Category? category;

  @override
  void initState() {
    // context.read<CategoryCubit>().getCategories();
    super.initState();
  }

  Widget _buildBodyContent() {
    return BlocConsumer<CategoryCubit, CategoryState>(
      listener: (context, state) {
        if (state is CategoryAddOrEditSuccess) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is CategoryIsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CategoryError) {
          return error_widget.ErrorWidget(
            onPress: () {},
          );
        } else if (state is CategoryInitial) {
          return AddEditCategoryContent(
            category: category,
          );
        } else {
          return const Text('Unknown');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.settings.arguments != null) {
      final args = ModalRoute.of(context)?.settings.arguments as Map;
      category = args['category'];
    }

    final appBar = AppBar(
      title: category == null
          ? Text(AppLocalizations.of(context)!.translate('add_category')!)
          : Text(AppLocalizations.of(context)!.translate('edit_category')!),
    );
    return Scaffold(
      appBar: appBar,
      body: _buildBodyContent(),
    );
  }
}
