import '../constants/app_constants.dart';

/// Formats a price value into a human-readable string with thousands separator
/// and the appropriate price sign based on the unit setting.
///
/// [price] is the price value to format.
/// [unit] is the currency unit (0 for toman and 1 for rial).
///
/// Returns the formatted price as a [String].
String formatPrice(int price, int unit) {
  if (unit == 1) {
    price *= 10;
  }

  final unitText = getCurrencyUnit(unit);
  final formattedNumber = addThousandsSeparator(price.toString());

  return '$formattedNumber $unitText';
}

/// Returns the appropriate currency unit based on the unit setting.
///
/// [unit] is the currency unit identifier.
///
/// Returns the currency unit as a [String].
String getCurrencyUnit(int unit) {
  return unit == 0 ? AppConstants.toman : AppConstants.rial;
}

/// Adds thousands separator to a number string.
///
/// [numberString] is the number as a string.
///
/// Returns the formatted number string with commas.
String addThousandsSeparator(String numberString) {
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

/// Formats a price for display without currency unit.
///
/// [price] is the price value to format.
///
/// Returns the formatted price as a [String].
String formatPriceOnly(int price) {
  return addThousandsSeparator(price.toString());
}

String formatUsd(double amount) {
  final sign = amount < 0 ? '-' : '';
  final absolute = amount.abs();
  final intPart = absolute.floor();
  final decimalPart = absolute - intPart;
  final formattedInt = addThousandsSeparator(intPart.toString());
  final decimals =
      decimalPart > 0 ? decimalPart.toStringAsFixed(2).substring(1) : '.00';
  return '$sign\$$formattedInt$decimals';
}
