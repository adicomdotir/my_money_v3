import 'package:flutter_test/flutter_test.dart';
import 'package:my_money_v3/core/utils/utils.dart';

void main() {
  group('getPersianMonthName', () {
    test('should return correct Persian month name for valid month numbers',
        () {
      expect(getPersianMonthName(1 - 1), 'فروردین');
      expect(getPersianMonthName(2 - 1), 'اردیبهشت');
      expect(getPersianMonthName(3 - 1), 'خرداد');
      expect(getPersianMonthName(4 - 1), 'تیر');
      expect(getPersianMonthName(5 - 1), 'مرداد');
      expect(getPersianMonthName(6 - 1), 'شهریور');
      expect(getPersianMonthName(7 - 1), 'مهر');
      expect(getPersianMonthName(8 - 1), 'آبان');
      expect(getPersianMonthName(9 - 1), 'آذر');
      expect(getPersianMonthName(10 - 1), 'دی');
      expect(getPersianMonthName(11 - 1), 'بهمن');
      expect(getPersianMonthName(12 - 1), 'اسفند');
    });
  });
}
