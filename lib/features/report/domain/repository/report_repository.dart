import 'package:dartz/dartz.dart';
import 'package:my_money_v3/core/error/failures.dart';
import 'package:my_money_v3/features/report/domain/entities/report_entity.dart';

abstract class ReportRepository {
  Future<Either<Failure, ReportEnitty>> getReport();
}
