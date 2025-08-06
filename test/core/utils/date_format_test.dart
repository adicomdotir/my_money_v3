import 'package:flutter_test/flutter_test.dart';
import 'package:my_money_v3/core/utils/utils.dart';

void main() {
  group('formatDate', () {
    test('should format date with single digit month and day correctly', () {
      // March 5, 2024 (1402/12/15 in Jalali)
      final timestamp = 1709654400000; // milliseconds

      final result = formatDate(timestamp);

      expect(result, '1402/12/15');
    });

    test('should format date with double digit month and day correctly', () {
      // October 15, 2023 (1402/07/23 in Jalali)
      final timestamp = 1697328000000; // milliseconds

      final result = formatDate(timestamp);

      expect(result, '1402/07/23');
    });

    test('should handle year transition correctly', () {
      // March 20, 2024 (1403/01/01 in Jalali - New Year)
      final timestamp = 1710892800000; // milliseconds

      final result = formatDate(timestamp);

      expect(result, '1403/01/01');
    });
  });
}
