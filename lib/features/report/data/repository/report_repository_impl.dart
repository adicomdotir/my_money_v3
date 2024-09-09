import 'package:dartz/dartz.dart';
import 'package:my_money_v3/core/error/failures.dart';
import 'package:my_money_v3/features/report/data/data_sources/report_data_source.dart';

import '../../domain/entities/report_entity.dart';
import '../../domain/repository/report_repository.dart';

class ReportRepositoryImpl extends ReportRepository {
  final ReportDataSource reportDataSource;

  ReportRepositoryImpl({required this.reportDataSource});

  @override
  Future<Either<Failure, List<ReportEntity>>> getReport() async {
    final result = await reportDataSource.getReport();
    try {
      return Right(ReportEntity.fromModel(result));
    } on Exception catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
