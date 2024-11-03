import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/splash/presentation/bloc/global_bloc.dart';

import 'config/locale/app_localizations_setup.dart';
import 'config/routes/app_routes.dart';
import 'core/utils/app_strings.dart';
import 'injection_container.dart' as di;

class MyMoneyApp extends StatelessWidget {
  const MyMoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              di.sl<GlobalBloc>()..add(GetSettingsGlobalEvent()),
        ),
      ],
      child: BlocBuilder<GlobalBloc, GlobalState>(
        buildWhen: (GlobalState previousState, GlobalState currentState) {
          return previousState != currentState;
        },
        builder: (BuildContext context, GlobalState state) {
          return MaterialApp(
            title: AppStrings.appName,
            locale: state.settings.locale,
            debugShowCheckedModeBanner: false,
            // The Mandy red, light theme.
            theme: FlexThemeData.light(
              scheme: FlexScheme.pinkM3,
              fontFamily: 'Vazir',
            ),
            // The Mandy red, dark theme.
            darkTheme: FlexThemeData.dark(
              scheme: FlexScheme.pinkM3,
              fontFamily: 'Vazir',
            ),
            // Use dark or light theme based on system setting.
            themeMode: ThemeMode.light,
            // themeMode: ThemeMode.light,
            // theme: ThemeData(
            //   useMaterial3: true,
            //   colorScheme: lightColorScheme,
            //   fontFamily: 'Vazir',
            // ),
            // darkTheme: ThemeData(
            //   useMaterial3: true,
            //   colorScheme: darkColorScheme,
            // ),
            onGenerateRoute: AppRoutes.onGenerateRoute,
            supportedLocales: AppLocalizationsSetup.supportedLocales,
            localeResolutionCallback:
                AppLocalizationsSetup.localeResolutionCallback,
            localizationsDelegates:
                AppLocalizationsSetup.localizationsDelegates,
          );
        },
      ),
    );
  }
}
