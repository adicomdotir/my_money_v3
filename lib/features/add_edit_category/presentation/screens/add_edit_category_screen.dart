import 'package:my_money_v3/core/domain/entities/category.dart';
import 'package:my_money_v3/core/widgets/error_widget.dart' as error_widget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_money_v3/features/add_edit_category/presentation/widgets/add_edit_category_content.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../cubit/add_edit_category_cubit.dart';

class AddEditCategoryScreen extends StatefulWidget {
  const AddEditCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddEditCategoryScreen> createState() => _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends State<AddEditCategoryScreen> {
  Category? category;

  @override
  void initState() {
    context.read<AddEditCategoryCubit>().getCategories();
    super.initState();
  }

  Widget _buildBodyContent() {
    return BlocConsumer<AddEditCategoryCubit, AddEditCategoryState>(
      listener: (context, state) {
        if (state is AddEditCategorySuccess) {
          Navigator.pop(context);
        }
      },
      builder: ((context, state) {
        if (state is AddEditCategoryIsLoading) {
          return Center(
            child: SpinKitFadingCircle(
              color: AppColors.primary,
            ),
          );
        } else if (state is AddEditCategoryError) {
          return error_widget.ErrorWidget(
            onPress: () {},
          );
        } else if (state is AddEditCategoryLoaded) {
          return Column(
            children: const [],
          );
        } else if (state is AddEditCategorySuccess) {
          // Navigator.pop(context);
          return Container();
        } else if (state is AddEditCategoryListLoaded) {
          return AddEditCategoryContent(
            categories: state.categories,
            category: category,
          );
        } else {
          return const AddEditCategoryContent(
            categories: [],
          );
        }
      }),
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
