import 'package:dartz/dartz.dart';
import 'package:my_money_v3/core/error/failures.dart';

import '../entities/report_entity.dart';

abstract class ReportRepository {
  Future<Either<Failure, List<ReportEntity>>> getReport();
}
