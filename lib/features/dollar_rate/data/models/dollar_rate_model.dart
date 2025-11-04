import 'package:my_money_v3/features/dollar_rate/domain/entities/dollar_rate.dart';

class DollarRateModel extends DollarRate {
  const DollarRateModel({
    required super.year,
    required super.month,
    required super.price,
  });

  factory DollarRateModel.fromMap(Map<String, dynamic> json) {
    return DollarRateModel(
      year: json['year'] as int,
      month: json['month'] as int,
      price: json['price'] as int,
    );
  }

  Map<String, dynamic> toMap() => {
        'year': year,
        'month': month,
        'price': price,
      };
}
