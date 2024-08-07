import 'package:flutter_test/flutter_test.dart';
import 'package:my_money_v3/core/utils/price_format.dart';

void main() {
  test('priceSign returns \'TOMAN\' when unit is 0', () {
    final result = priceSignString(0);

    expect(result, 'تومان');
  });

  test('priceSign returns \'RIAL\' when unit is not 0', () {
    final result = priceSignString(1);

    expect(result, 'ریال');
  });
}
