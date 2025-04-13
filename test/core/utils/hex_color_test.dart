import 'package:flutter_test/flutter_test.dart';
import 'package:my_money_v3/core/utils/hex_color.dart';

void main() {
  group('HexColor', () {
    test('creates color from 3-digit RGB format', () {
      final color = HexColor('F00');
      expect(color.value, 0xFFFF0000);

      final color2 = HexColor('#F00');
      expect(color2.value, 0xFFFF0000);
    });

    test('creates color from 6-digit RRGGBB format', () {
      final color = HexColor('FF0000');
      expect(color.value, 0xFFFF0000);

      final color2 = HexColor('#FF0000');
      expect(color2.value, 0xFFFF0000);
    });

    test('creates color from 8-digit AARRGGBB format', () {
      final color = HexColor('80FF0000');
      expect(color.value, 0x80FF0000);

      final color2 = HexColor('#80FF0000');
      expect(color2.value, 0x80FF0000);
    });

    test('handles empty string by returning white', () {
      final color = HexColor('');
      expect(color.value, 0xFFFFFFFF);
    });

    test('throws FormatException for invalid formats', () {
      expect(() => HexColor('GG0000'), throwsFormatException);
      expect(() => HexColor('FF00'), throwsFormatException);
      expect(() => HexColor('FF000000FF'), throwsFormatException);
    });

    test('handles various color values correctly', () {
      expect(HexColor('000').value, 0xFF000000);
      expect(HexColor('FFF').value, 0xFFFFFFFF);
      expect(HexColor('888').value, 0xFF888888);
      expect(HexColor('00FF00').value, 0xFF00FF00);
      expect(HexColor('7FFFFFFF').value, 0x7FFFFFFF);
    });
  });
}
