// lib/utils/colors/color_parser.dart
import 'package:flutter/material.dart';

extension ColorConversion on String {
  Color toColor({Color fallback = Colors.black}) {
    if (isEmpty) {
      return fallback;
    }

    try {
      String color = toUpperCase().replaceAll('#', '');
      if (color.length == 6) {
        color = 'FF$color';
      } else if (color.length != 8) {
        return fallback;
      }

      final colorValue = int.tryParse(color, radix: 16);
      return colorValue != null ? Color(colorValue) : fallback;
    } on Exception catch (_) {
      return fallback;
    }
  }
}
