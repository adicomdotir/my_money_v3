import 'package:flutter/material.dart';

import 'hex_color.dart';

class AppColors {
  const AppColors._();

  // Theme Colors
  static const Color primary = Colors.blue;
  static const Color hint = Colors.grey;

  // Common Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  // Semantic Colors
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.orange;
  static const Color info = Colors.blue;

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  /// Creates a color from a hex string
  static Color fromHex(String hexColor) {
    return HexColor(hexColor);
  }

  /// Generates the opposite color (black or white) based on background color
  static Color getOppositeColor(String hexColor) {
    hexColor = hexColor.startsWith('#') ? hexColor : '#$hexColor';
    Color resultColor = Colors.white;

    try {
      final color = hexColor.substring(1);
      final red = int.parse(color.substring(0, 2), radix: 16);
      final green = int.parse(color.substring(2, 4), radix: 16);
      final blue = int.parse(color.substring(4), radix: 16);
      final bgColor = Color.fromRGBO(red, green, blue, 1.0);
      resultColor =
          bgColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    } on Exception catch (_) {
      // Return white as default if parsing fails
    }

    return resultColor;
  }
}
