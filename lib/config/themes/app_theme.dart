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

const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF246D00),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFF99FA6F),
  onPrimaryContainer: Color(0xFF062100),
  secondary: Color(0xFF55624C),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFD8E7CB),
  onSecondaryContainer: Color(0xFF131F0D),
  tertiary: Color(0xFF386667),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFBBEBEC),
  onTertiaryContainer: Color(0xFF002021),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  surface: Color(0xFFFDFDF6),
  onSurface: Color(0xFF1A1C18),
  surfaceContainerHighest: Color(0xFFDFE4D7),
  onSurfaceVariant: Color(0xFF43483E),
  outline: Color(0xFF73796D),
  onInverseSurface: Color(0xFFF1F1EA),
  inverseSurface: Color(0xFF2F312D),
  inversePrimary: Color(0xFF7EDD56),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF246D00),
  outlineVariant: Color(0xFFC3C8BB),
  scrim: Color(0xFF000000),
);

const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF7EDD56),
  onPrimary: Color(0xFF0F3900),
  primaryContainer: Color(0xFF195200),
  onPrimaryContainer: Color(0xFF99FA6F),
  secondary: Color(0xFFBCCBB0),
  onSecondary: Color(0xFF273421),
  secondaryContainer: Color(0xFF3E4A36),
  onSecondaryContainer: Color(0xFFD8E7CB),
  tertiary: Color(0xFFA0CFD0),
  onTertiary: Color(0xFF003738),
  tertiaryContainer: Color(0xFF1E4E4F),
  onTertiaryContainer: Color(0xFFBBEBEC),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  surface: Color(0xFF1A1C18),
  onSurface: Color(0xFFE3E3DC),
  surfaceContainerHighest: Color(0xFF43483E),
  onSurfaceVariant: Color(0xFFC3C8BB),
  outline: Color(0xFF8D9287),
  onInverseSurface: Color(0xFF1A1C18),
  inverseSurface: Color(0xFFE3E3DC),
  inversePrimary: Color(0xFF246D00),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF7EDD56),
  outlineVariant: Color(0xFF43483E),
  scrim: Color(0xFF000000),
);
