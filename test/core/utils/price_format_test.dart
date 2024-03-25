import 'package:flutter_test/flutter_test.dart';

void main() {
  test('priceSign returns تومان when unit is 0', () {
  var context = // provide a valid BuildContext for testing
  final bloc = GlobalBloc(MockSettingsState(unit: 0));
  
  final result = priceSign(context);
  
  expect(result, 'تومان');
});

test('priceSign returns ریال when unit is not 0', () {
  var context = // provide a valid BuildContext for testing
  final bloc = GlobalBloc(MockSettingsState(unit: 1));
  
  final result = priceSign(context);
  
  expect(result, 'ریال');
});
}