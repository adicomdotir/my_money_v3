import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/dollar_rate_repository.dart';

class DeleteDollarRateUseCase
    implements UseCaseWithParam<void, DeleteDollarRateParams> {
  final DollarRateRepository repository;

  DeleteDollarRateUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(DeleteDollarRateParams params) =>
      repository.deleteDollarRate(params.year, params.month);
}

class DeleteDollarRateParams extends Equatable {
  final int year;
  final int month;

  const DeleteDollarRateParams({
    required this.year,
    required this.month,
  });

  @override
  List<Object?> get props => [year, month];
}
