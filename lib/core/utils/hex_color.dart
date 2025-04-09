import 'dart:ui';

import 'package:flutter/material.dart';

class HexColor extends Color {
  static int getColorFromHex(String hexColor) {
    // Remove any leading '#' and convert to uppercase
    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    // Handle different hex formats
    switch (hexColor.length) {
      case 0:
        return 0xFFFFFFFF; // Default to white if empty
      case 3: // RGB format
        final r = hexColor[0];
        final g = hexColor[1];
        final b = hexColor[2];
        return int.parse('FF$r$r$g$g$b$b', radix: 16);
      case 6: // RRGGBB format
        return int.parse('FF$hexColor', radix: 16);
      case 8: // AARRGGBB format
        return int.parse(hexColor, radix: 16);
      default:
        throw FormatException('Invalid hex color format: $hexColor');
    }
  }

  /// Creates a color from a hex string.
  ///
  /// Supported formats:
  /// - #RGB
  /// - #RRGGBB
  /// - #AARRGGBB
  /// - RGB
  /// - RRGGBB
  /// - AARRGGBB
  ///
  /// Throws [FormatException] if the hex string is invalid.
  HexColor(String hexColor) : super(getColorFromHex(hexColor));
}
