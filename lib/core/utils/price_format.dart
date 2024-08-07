/// Formats a price value into a human-readable string with thousands separator
/// and the appropriate price sign based on the unit setting in the global state.
///
/// [price] is the price value to format.
/// [context] is the build context from which to obtain the global state.
///
/// Returns the formatted price as a [String].
String priceFormat(int price, int unit) {
  if (unit == 1) {
    price *= 10;
  }
  final unitText = priceSignString(unit);
  final len = price.toString().length;
  final buffer = StringBuffer();
  for (var i = 0; i < len; i++) {
    if (i != 0 && i % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(price.toString()[len - i - 1]);
  }
  return '${buffer.toString().split('').reversed.join('')} $unitText';
}

/// Returns the appropriate price sign based on the unit setting in the global state.
///
/// [context] is the build context from which to obtain the global state.
///
/// Returns the price sign as a [String].
String priceSignString(int unit) {
  // final int unit = BlocProvider.of<GlobalBloc>(context).state.settings.unit;
  return unit == 0 ? 'تومان' : 'ریال';
}
