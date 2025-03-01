import 'package:persian_datetime_picker/persian_datetime_picker.dart';

String dateFormat(int milliseconds) {
  final date = Jalali.fromDateTime(
    DateTime.fromMillisecondsSinceEpoch(milliseconds),
  );
  // Add padding for single digit months and days
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}/$month/$day';
}
