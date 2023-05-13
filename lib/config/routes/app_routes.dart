import 'package:my_money_v3/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/app_strings.dart';
import '../../features/category/presentation/cubit/category_cubit.dart';
import '../../features/category/presentation/screens/add_edit_category_screen.dart';
import '../../features/category/presentation/screens/category_list_screen.dart';
import '../../features/expense/presentation/cubit/add_edit_expense_cubit.dart';
import '../../features/expense/presentation/cubit/expense_list_cubit.dart';
import '../../features/expense/presentation/screens/add_edit_expense_screen.dart';
import '../../features/expense/presentation/screens/expense_list_screen.dart';
import '../../features/home/presentation/cubit/home_info_cubit.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

class Routes {
  static const String initialRoute = '/';
  static const String homeRoute = '/homeRoute';
  static const String addEditExpanseRoute = '/addEditExpanseRoute';
  static const String addEditCategoryRoute = '/addEditCategoryRoute';
  static const String expenseListRoute = '/expenseListRoute';
  static const String categoryListRoute = '/categoryListRoute';
}

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.initialRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const SplashScreen();
          },
        );
      case Routes.homeRoute:
        return MaterialPageRoute(
          builder: ((context) {
            return BlocProvider(
              create: ((context) => di.sl<HomeInfoCubit>()),
              child: const HomeScreen(),
            );
          }),
        );
      case Routes.addEditExpanseRoute:
        return MaterialPageRoute(
          builder: ((context) {
            return BlocProvider(
              create: ((context) => di.sl<AddEditExpenseCubit>()),
              child: const AddEditExpenseScreen(),
            );
          }),
          settings: routeSettings,
        );
      case Routes.addEditCategoryRoute:
        return MaterialPageRoute(
          builder: ((context) {
            return BlocProvider(
              create: ((context) => di.sl<CategoryCubit>()),
              child: const AddEditCategoryScreen(),
            );
          }),
          settings: routeSettings,
        );
      case Routes.expenseListRoute:
        return MaterialPageRoute(
          builder: ((context) {
            return BlocProvider(
              create: ((context) => di.sl<ExpenseListCubit>()),
              child: const ExpenseListScreen(),
            );
          }),
        );
      case Routes.categoryListRoute:
        return MaterialPageRoute(
          builder: ((context) {
            return BlocProvider(
              create: ((context) => di.sl<CategoryCubit>()),
              child: const CategoryListScreen(),
            );
          }),
        );
      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
      builder: ((context) => const Scaffold(
            body: Center(
              child: Text(AppStrings.noRouteFound),
            ),
          )),
    );
  }
}
