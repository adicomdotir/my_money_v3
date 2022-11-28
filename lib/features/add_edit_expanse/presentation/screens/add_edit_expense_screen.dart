import 'package:my_money_v3/config/routes/app_routes.dart';
import 'package:my_money_v3/core/widgets/error_widget.dart' as error_widget;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_money_v3/features/add_edit_expanse/presentation/widgets/add_edit_expense_content.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../splash/presentation/cubit/locale_cubit.dart';
import '../cubit/add_edit_expense_cubit.dart';

class AddEditExpenseScreen extends StatefulWidget {
  const AddEditExpenseScreen({Key? key}) : super(key: key);

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildBodyContent() {
    return BlocBuilder<AddEditExpenseCubit, AddEditExpenseState>(
      builder: ((context, state) {
        if (state is AddEditExpenseIsLoading) {
          return Center(
            child: SpinKitFadingCircle(
              color: AppColors.primary,
            ),
          );
        } else if (state is AddEditExpenseError) {
          return error_widget.ErrorWidget(
            onPress: () {},
          );
        } else if (state is AddEditExpenseLoaded) {
          return Column(
            children: [
              AddEditExpenseContent(
                expense: state.expense,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: const Icon(
                    Icons.refresh,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        } else {
          return const AddEditExpenseContent();
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(AppLocalizations.of(context)!.translate('add_expense')!),
    );
    return Scaffold(
      appBar: appBar,
      body: _buildBodyContent(),
    );
  }
}
