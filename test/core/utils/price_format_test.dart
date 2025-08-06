import 'package:flutter_test/flutter_test.dart';
import 'package:my_money_v3/core/utils/utils.dart';

void main() {
  test('priceSign returns \'TOMAN\' when unit is 0', () {
    final result = getCurrencyUnit(0);

    expect(result, 'تومان');
  });

  test('priceSign returns \'RIAL\' when unit is not 0', () {
    final result = getCurrencyUnit(1);

    expect(result, 'ریال');
  });
}
