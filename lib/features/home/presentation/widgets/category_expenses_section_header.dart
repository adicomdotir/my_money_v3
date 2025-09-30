import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/config/routes/app_routes.dart';
import 'package:my_money_v3/features/home/presentation/cubit/home_info_cubit.dart';

class CategoryExpensesSectionHeader extends StatelessWidget {
  const CategoryExpensesSectionHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'هزینه‌ها بر اساس دسته‌بندی',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, Routes.expenseListRoute).then((value) {
              if (context.mounted) {
                BlocProvider.of<HomeInfoCubit>(context).getHomeInfo();
              }
            });
          },
          icon: Icon(Icons.list, size: 18),
          label: Text('همه'),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
        ),
      ],
    );
  }
}
