import 'package:my_money_v3/features/report/domain/entities/report_entity.dart';

import 'package:my_money_v3/core/error/failures.dart';

import 'package:dartz/dartz.dart';

import '../../domain/repository/report_repository.dart';

class ReportRepositoryImpl extends ReportRepository {
  @override
  Future<Either<Failure, ReportEnitty>> getReport() {
    // TODO: implement getReport
    throw UnimplementedError();
  }
}
