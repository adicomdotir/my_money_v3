import 'package:flutter_test/flutter_test.dart';
import 'package:my_money_v3/core/utils/functions/functions.dart';

void main() {
  group('getMonthName', () {
    test('should return correct Persian month name for valid month numbers',
        () {
      expect(getMonthName(1 - 1), 'فروردین');
      expect(getMonthName(2 - 1), 'اردیبهشت');
      expect(getMonthName(3 - 1), 'خرداد');
      expect(getMonthName(4 - 1), 'تیر');
      expect(getMonthName(5 - 1), 'مرداد');
      expect(getMonthName(6 - 1), 'شهریور');
      expect(getMonthName(7 - 1), 'مهر');
      expect(getMonthName(8 - 1), 'آبان');
      expect(getMonthName(9 - 1), 'آذر');
      expect(getMonthName(10 - 1), 'دی');
      expect(getMonthName(11 - 1), 'بهمن');
      expect(getMonthName(12 - 1), 'اسفند');
    });
  });
}
