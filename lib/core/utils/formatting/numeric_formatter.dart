import 'package:flutter/services.dart';

/// Text input formatter that only allows numeric input with thousands separator.
class NumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      final int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.end;
      var value = newValue.text;
      if (newValue.text.length > 2) {
        value = value.replaceAll(RegExp(r'\D'), '');
        value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      }
      return TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(
          offset: value.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}

/// Text input formatter that only allows numeric input.
class NumericOnlyFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove any non-numeric characters
    final filtered = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}

/// Text input formatter that allows decimal numbers.
class DecimalFormatter extends TextInputFormatter {
  final int decimalPlaces;

  DecimalFormatter({this.decimalPlaces = 2});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow only numbers and one decimal point
    final filtered = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Ensure only one decimal point
    final parts = filtered.split('.');
    if (parts.length > 2) {
      return oldValue;
    }

    // Limit decimal places
    if (parts.length == 2 && parts[1].length > decimalPlaces) {
      return oldValue;
    }

    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}

/// Formats a number with thousands separator.
///
/// [number] is the number to format.
///
/// Returns the formatted number as a [String].
String formatNumberWithSeparator(int number) {
  final numberString = number.toString();
  final len = numberString.length;
  final buffer = StringBuffer();

  for (var i = 0; i < len; i++) {
    if (i != 0 && i % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(numberString[len - i - 1]);
  }

  return buffer.toString().split('').reversed.join('');
}

/// Parses a string with thousands separator to an integer.
///
/// [formattedString] is the formatted string to parse.
///
/// Returns the parsed integer.
int parseFormattedNumber(String formattedString) {
  final cleanString = formattedString.replaceAll(',', '');
  return int.tryParse(cleanString) ?? 0;
}
