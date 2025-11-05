import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/dollar_rate/data/models/dollar_rate_model.dart';
import 'package:my_money_v3/features/dollar_rate/domain/entities/dollar_rate.dart';
import 'package:my_money_v3/features/dollar_rate/domain/usecases/delete_dollar_rate_use_case.dart';
import 'package:my_money_v3/features/dollar_rate/domain/usecases/get_all_dollar_rates_use_case.dart';
import 'package:my_money_v3/features/dollar_rate/domain/usecases/upsert_dollar_rate_use_case.dart';

import '../../../../core/error/failures.dart';

part 'dollar_rate_state.dart';

class DollarRateCubit extends Cubit<DollarRateState> {
  final GetAllDollarRatesUseCase getAllDollarRatesUseCase;
  final UpsertDollarRateUseCase upsertDollarRateUseCase;
  final DeleteDollarRateUseCase deleteDollarRateUseCase;

  DollarRateCubit({
    required this.getAllDollarRatesUseCase,
    required this.upsertDollarRateUseCase,
    required this.deleteDollarRateUseCase,
  }) : super(DollarRateInitial());

  Future<void> getAllDollarRates() async {
    emit(DollarRateLoading());
    final Either<Failure, List<DollarRate>> response =
        await getAllDollarRatesUseCase();
    emit(
      response.fold(
        (failure) => DollarRateError(message: failure.message),
        (rates) => DollarRateLoaded(rates: rates),
      ),
    );
  }

  Future<void> upsertDollarRate(DollarRateModel rate) async {
    emit(DollarRateLoading());
    final Either<Failure, void> response =
        await upsertDollarRateUseCase(UpsertDollarRateParams(rate));
    emit(
      response.fold(
        (failure) => DollarRateError(message: failure.message),
        (_) => DollarRateSuccess(),
      ),
    );
    // Reload after success
    await getAllDollarRates();
  }

  Future<void> deleteDollarRate(int year, int month) async {
    emit(DollarRateLoading());
    final Either<Failure, void> response = await deleteDollarRateUseCase(
      DeleteDollarRateParams(year: year, month: month),
    );
    emit(
      response.fold(
        (failure) => DollarRateError(message: failure.message),
        (_) => DollarRateSuccess(),
      ),
    );
    // Reload after success
    await getAllDollarRates();
  }
}
