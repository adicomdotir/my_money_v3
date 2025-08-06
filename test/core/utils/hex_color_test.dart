import 'package:flutter_test/flutter_test.dart';
import 'package:my_money_v3/core/utils/utils.dart';

void main() {
  group('HexColor', () {
    test('creates color from 3-digit RGB format', () {
      final color = HexColor.getColorFromHex('hexColor');
      expect(color, 0xFFFF0000);

      final color2 = HexColor.getColorFromHex('#F00');
      expect(color2, 0xFFFF0000);
    });

    test('creates color from 6-digit RRGGBB format', () {
      final color = HexColor.getColorFromHex('FF0000');
      expect(color, 0xFFFF0000);

      final color2 = HexColor.getColorFromHex('#FF0000');
      expect(color2, 0xFFFF0000);
    });

    test('creates color from 8-digit AARRGGBB format', () {
      final color = HexColor.getColorFromHex('80FF0000');
      expect(color, 0x80FF0000);

      final color2 = HexColor.getColorFromHex('#80FF0000');
      expect(color2, 0x80FF0000);
    });

    test('handles empty string by returning white', () {
      final color = HexColor.getColorFromHex('');
      expect(color, 0xFFFFFFFF);
    });

    test('throws FormatException for invalid formats', () {
      expect(() => HexColor.getColorFromHex('GG0000'), throwsFormatException);
      expect(() => HexColor.getColorFromHex('FF00'), throwsFormatException);
      expect(
        () => HexColor.getColorFromHex('FF000000FF'),
        throwsFormatException,
      );
    });

    test('handles various color values correctly', () {
      expect(HexColor.getColorFromHex('000'), 0xFF000000);
      expect(HexColor.getColorFromHex('FFF'), 0xFFFFFFFF);
      expect(HexColor.getColorFromHex('888'), 0xFF888888);
      expect(HexColor.getColorFromHex('00FF00'), 0xFF00FF00);
      expect(HexColor.getColorFromHex('7FFFFFFF'), 0x7FFFFFFF);
    });
  });
}
