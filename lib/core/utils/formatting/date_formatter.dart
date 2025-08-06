import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../constants/app_constants.dart';

/// Formats a date from milliseconds to Persian date string.
///
/// [milliseconds] is the date in milliseconds since epoch.
///
/// Returns the formatted date as a [String] in format YYYY/MM/DD.
String formatDate(int milliseconds) {
  final date = Jalali.fromDateTime(
    DateTime.fromMillisecondsSinceEpoch(milliseconds),
  );

  // Add padding for single digit months and days
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');

  return '${date.year}/$month/$day';
}

/// Formats a date from milliseconds to Persian date string with month name.
///
/// [milliseconds] is the date in milliseconds since epoch.
///
/// Returns the formatted date as a [String] in format "DD MonthName YYYY".
String formatDateWithMonthName(int milliseconds) {
  final date = Jalali.fromDateTime(
    DateTime.fromMillisecondsSinceEpoch(milliseconds),
  );

  final monthName = getPersianMonthName(date.month - 1);
  final day = date.day.toString().padLeft(2, '0');

  return '$day $monthName ${date.year}';
}

/// Gets the Persian month name by index.
///
/// [monthIndex] is the month index (0-11).
///
/// Returns the Persian month name as a [String].
String getPersianMonthName(int monthIndex) {
  if (monthIndex >= 0 && monthIndex < AppConstants.persianMonths.length) {
    return AppConstants.persianMonths[monthIndex];
  }
  return '';
}

/// Formats a date from milliseconds to short Persian date string.
///
/// [milliseconds] is the date in milliseconds since epoch.
///
/// Returns the formatted date as a [String] in format "MM/DD".
String formatShortDate(int milliseconds) {
  final date = Jalali.fromDateTime(
    DateTime.fromMillisecondsSinceEpoch(milliseconds),
  );

  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');

  return '$month/$day';
}

/// Gets the current Persian date as a formatted string.
///
/// Returns the current date as a [String] in format YYYY/MM/DD.
String getCurrentPersianDate() {
  final now = DateTime.now();
  final persianDate = Jalali.fromDateTime(now);

  final month = persianDate.month.toString().padLeft(2, '0');
  final day = persianDate.day.toString().padLeft(2, '0');

  return '${persianDate.year}/$month/$day';
}
