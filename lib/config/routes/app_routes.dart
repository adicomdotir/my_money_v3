import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/expense/presentation/add_edit_expense/cubit/add_edit_expense_cubit.dart';
import 'package:my_money_v3/features/expense/presentation/add_edit_expense/screens/add_edit_expense_screen.dart';
import 'package:my_money_v3/features/expense/presentation/expense_list/cubit/expense_cubit.dart';
import 'package:my_money_v3/features/expense/presentation/expense_list/screens/expense_list_screen.dart';
import 'package:my_money_v3/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:my_money_v3/features/settings/presentation/screens/settings_screen.dart';

import '../../core/utils/app_strings.dart';
import '../../features/category/presentation/cubit/category_cubit.dart';
import '../../features/category/presentation/screens/add_edit_category_screen.dart';
import '../../features/category/presentation/screens/category_list_screen.dart';
import '../../features/home/presentation/cubit/home_info_cubit.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/report/presentation/bloc/report_bloc.dart';
import '../../features/report/presentation/screen/report_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../injection_container.dart' as di;
import '../../shared/category_drop_down/presentation/cubit/categories_drop_down_cubit.dart';

class Routes {
  static const String initialRoute = '/';
  static const String homeRoute = '/home_route';
  static const String addEditExpanseRoute = '/add_edit_expanse_route';
  static const String addEditCategoryRoute = '/add_edit_category_route';
  static const String expenseListRoute = '/expense_list_route';
  static const String categoryListRoute = '/category_list_route';
  static const String reportRoute = '/report_route';
  static const String settingsRoute = '/settings_route';
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
          builder: (context) {
            return BlocProvider(
              create: (context) => di.sl<HomeInfoCubit>(),
              child: const HomeScreen(),
            );
          },
        );
      case Routes.addEditExpanseRoute:
        return MaterialPageRoute(
          builder: ((context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: ((context) => di.sl<AddEditExpenseCubit>()),
                ),
                BlocProvider(
                  create: ((context) => di.sl<CategoriesDropDownCubit>()),
                ),
              ],
              child: const AddEditExpenseScreen(),
            );
          }),
          settings: routeSettings,
        );
      case Routes.addEditCategoryRoute:
        return MaterialPageRoute(
          builder: ((context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: ((context) => di.sl<CategoryCubit>()),
                ),
                BlocProvider(
                  create: ((context) => di.sl<CategoriesDropDownCubit>()),
                ),
              ],
              child: const AddEditCategoryScreen(),
            );
          }),
          settings: routeSettings,
        );
      case Routes.expenseListRoute:
        return MaterialPageRoute(
          builder: ((context) {
            return BlocProvider(
              create: ((context) => di.sl<ExpenseCubit>()),
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
      case Routes.reportRoute:
        return MaterialPageRoute(
          builder: ((context) {
            return BlocProvider(
              create: (context) => di.sl<ReportBloc>(),
              child: const ReportScreen(),
            );
          }),
        );
      case Routes.settingsRoute:
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider(
              create: (context) => di.sl<SettingsBloc>(),
              child: const SettingsScreen(),
            );
          },
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
