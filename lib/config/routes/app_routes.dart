import 'package:my_money_v3/features/add_edit_category/presentation/cubit/add_edit_category_cubit.dart';
import 'package:my_money_v3/features/add_edit_category/presentation/screens/add_edit_category_screen.dart';
import 'package:my_money_v3/features/add_edit_expanse/presentation/cubit/add_edit_expense_cubit.dart';
import 'package:my_money_v3/features/add_edit_expanse/presentation/screens/add_edit_expense_screen.dart';
import 'package:my_money_v3/features/expanse_list/presentation/cubit/expense_list_cubit.dart';
import 'package:my_money_v3/features/expanse_list/presentation/screens/expense_list_screen.dart';
import 'package:my_money_v3/features/home/presentation/screens/home_screen.dart';
import 'package:my_money_v3/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/app_strings.dart';
import '../../features/home/presentation/cubit/random_quote_cubit.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

class Routes {
  static const String initialRoute = '/';
  static const String randomQuoteRoute = '/randomQuote';
  static const String addEditExpanseRoute = '/addEditExpanseRoute';
  static const String addEditCategoryRoute = '/addEditCategoryRoute';
  static const String expenseListRoute = '/expenseListRoute';
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
      case Routes.randomQuoteRoute:
        return MaterialPageRoute(
          builder: ((context) {
            return BlocProvider(
              create: ((context) => di.sl<RandomQuoteCubit>()),
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
              create: ((context) => di.sl<AddEditCategoryCubit>()),
              child: const AddEditCategoryScreen(),
            );
          }),
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
