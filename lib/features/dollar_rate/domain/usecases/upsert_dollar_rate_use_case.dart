import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:my_money_v3/features/dollar_rate/data/models/dollar_rate_model.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/dollar_rate_repository.dart';

class UpsertDollarRateUseCase
    implements UseCaseWithParam<void, UpsertDollarRateParams> {
  final DollarRateRepository repository;

  UpsertDollarRateUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpsertDollarRateParams params) =>
      repository.upsertDollarRate(params.rate);
}

class UpsertDollarRateParams extends Equatable {
  final DollarRateModel rate;

  const UpsertDollarRateParams(this.rate);

  @override
  List<Object?> get props => [rate];
}
