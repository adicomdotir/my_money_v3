import 'package:persian_datetime_picker/persian_datetime_picker.dart';

String dateFormat(int milliseconds) {
  final date = Jalali.fromDateTime(
    DateTime.fromMillisecondsSinceEpoch(milliseconds),
  );
  return '${date.year}/${date.month}/${date.day}';
}
