import 'package:flutter/material.dart';

import '../../core/utils/app_colors.dart';
import '../../core/utils/app_strings.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: AppColors.primary,
    // hintColor: AppColors.hint,
    // scaffoldBackgroundColor: Colors.white,
    fontFamily: AppStrings.fontFamily,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
  );
  // return FlexThemeData.light(
  //   scheme: FlexScheme.dellGenoa,
  //   fontFamily: AppStrings.fontFamily,
  //   scaffoldBackground: Colors.grey[200],
  // );
}
