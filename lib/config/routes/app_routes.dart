import 'package:my_money_v3/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/app_strings.dart';
import '../../features/random_quote/presentation/cubit/random_quote_cubit.dart';
import '../../features/random_quote/presentation/screens/quote_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

class Routes {
  static const String initialRoute = '/';
  static const String randomQuoteRoute = '/randomQuote';
}

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.initialRoute:
        return MaterialPageRoute(builder: (context) {
          return const SplashScreen();
        });

      case Routes.randomQuoteRoute:
        return MaterialPageRoute(builder: ((context) {
          return BlocProvider(
            create: ((context) => di.sl<RandomQuoteCubit>()),
            child: const QuoteScreen(),
          );
        }));
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
            )));
  }
}
