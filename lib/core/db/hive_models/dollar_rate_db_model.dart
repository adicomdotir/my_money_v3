import 'package:hive_flutter/hive_flutter.dart';

import '../../../features/dollar_rate/data/models/dollar_rate_model.dart';

part 'dollar_rate_db_model.g.dart';

@HiveType(typeId: 5)
class DollarRateDbModel {
  const DollarRateDbModel({
    required this.year,
    required this.month,
    required this.price,
  });

  @HiveField(0)
  final int year;
  @HiveField(1)
  final int month;
  @HiveField(2)
  final int price;

  DollarRateModel toModel() =>
      DollarRateModel(year: year, month: month, price: price);
}

extension DollarRateDbMapper on DollarRateModel {
  DollarRateDbModel toDbModel() =>
      DollarRateDbModel(year: year, month: month, price: price);
}
