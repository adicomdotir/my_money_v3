import 'package:dartz/dartz.dart';
import 'package:my_money_v3/core/error/failures.dart';

import '../../data/model/report_model.dart';

abstract class ReportRepository {
  Future<Either<Failure, List<ReportModel>>> getReport();
}
