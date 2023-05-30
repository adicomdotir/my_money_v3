String priceFormat(int price) {
  int idx = 1;
  final priceString = price
      .toString()
      .split('')
      .reversed
      .reduce((value, element) {
        var newValue = value + element;
        if (idx % 3 == 0) {
          newValue = '$value,$element';
        }
        idx += 1;
        return newValue;
      })
      .split('')
      .reversed
      .join('');
  return '$priceString تومان';
}
