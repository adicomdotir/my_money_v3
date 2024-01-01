import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/core/bloc/global_bloc.dart';

String priceFormat(int price, BuildContext context) {
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
  String unitText = BlocProvider.of<GlobalBloc>(context).state.unitValue == 0
      ? 'تومان'
      : 'ریال';
  print(unitText);
  return '$priceString $unitText';
}
