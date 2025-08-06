import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_money_v3/core/bloc/global_bloc.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import 'config/routes/app_routes.dart';
import 'core/utils/utils.dart';
import 'injection_container.dart' as di;

class MyMoneyApp extends StatelessWidget {
  const MyMoneyApp({super.key});

  // Extracted list of BlocProviders for scalability
  List<BlocProvider> get _blocProviders => [
        BlocProvider(
          create: (context) =>
              di.sl<GlobalBloc>()..add(GetSettingsGlobalEvent()),
        ),
        // Add more BlocProviders here as your app grows
      ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _blocProviders,
      child: BlocBuilder<GlobalBloc, GlobalState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return MaterialApp(
            title: AppConstants.appName,
            locale: const Locale('fa', 'IR'),
            debugShowCheckedModeBanner: false,
            theme: context.watch<GlobalBloc>().state.themeData,
            darkTheme: FlexThemeData.dark(
              scheme: FlexScheme.pinkM3,
              fontFamily: 'Vazir',
            ),
            themeMode: ThemeMode.light,
            supportedLocales: const [
              Locale('fa', 'IR'),
            ],
            localizationsDelegates: const [
              PersianMaterialLocalizations.delegate,
              PersianCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            onGenerateRoute: AppRoutes.onGenerateRoute,
          );
        },
      ),
    );
  }
}
