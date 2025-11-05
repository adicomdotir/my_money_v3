import 'package:dartz/dartz.dart';
import 'package:my_money_v3/features/dollar_rate/data/models/dollar_rate_model.dart';
import 'package:my_money_v3/features/dollar_rate/domain/entities/dollar_rate.dart';

import '../../../../core/error/failures.dart';

abstract class DollarRateRepository {
  Future<Either<Failure, void>> upsertDollarRate(DollarRateModel rate);
  Future<Either<Failure, DollarRate?>> getDollarRate(int year, int month);
  Future<Either<Failure, List<DollarRate>>> getAllDollarRates();
  Future<Either<Failure, void>> deleteDollarRate(int year, int month);
}
