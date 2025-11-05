import 'package:dartz/dartz.dart';
import 'package:my_money_v3/features/dollar_rate/domain/entities/dollar_rate.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/dollar_rate_repository.dart';

class GetAllDollarRatesUseCase
    implements UseCaseWithoutParam<List<DollarRate>> {
  final DollarRateRepository repository;

  GetAllDollarRatesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<DollarRate>>> call() =>
      repository.getAllDollarRates();
}
