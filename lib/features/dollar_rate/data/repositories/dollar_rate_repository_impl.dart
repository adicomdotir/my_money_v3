import 'package:dartz/dartz.dart';
import 'package:my_money_v3/core/error/exceptions.dart';
import 'package:my_money_v3/features/dollar_rate/data/models/dollar_rate_model.dart';
import 'package:my_money_v3/features/dollar_rate/domain/entities/dollar_rate.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/dollar_rate_repository.dart';
import '../datasources/dollar_rate_local_data_source.dart';

class DollarRateRepositoryImpl implements DollarRateRepository {
  final DollarRateLocalDataSource localDataSource;

  DollarRateRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, void>> upsertDollarRate(DollarRateModel rate) async {
    try {
      await localDataSource.upsertDollarRate(rate);
      return const Right(null);
    } on DatabaseException catch (ex) {
      return Left(DatabaseFailure(message: ex.message));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DollarRate?>> getDollarRate(
    int year,
    int month,
  ) async {
    try {
      final result = await localDataSource.getDollarRate(year, month);
      return Right(result);
    } on DatabaseException catch (ex) {
      return Left(DatabaseFailure(message: ex.message));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DollarRate>>> getAllDollarRates() async {
    try {
      final result = await localDataSource.getAllDollarRates();
      return Right(result);
    } on DatabaseException catch (ex) {
      return Left(DatabaseFailure(message: ex.message));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDollarRate(int year, int month) async {
    try {
      await localDataSource.deleteDollarRate(year, month);
      return const Right(null);
    } on DatabaseException catch (ex) {
      return Left(DatabaseFailure(message: ex.message));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}
