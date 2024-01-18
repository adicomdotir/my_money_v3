import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/splash/presentation/bloc/global_bloc.dart';

String priceFormat(int price, BuildContext context) {
  if (BlocProvider.of<GlobalBloc>(context).state.settings.unit == 1) {
    price *= 10;
  }
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
  String unitText = priceSign(context);

  return '$priceString $unitText';
}

String priceSign(BuildContext context) {
  return BlocProvider.of<GlobalBloc>(context).state.settings.unit == 0
      ? 'تومان'
      : 'ریال';
}
