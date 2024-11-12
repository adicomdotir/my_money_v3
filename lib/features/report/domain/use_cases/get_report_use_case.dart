import 'package:dartz/dartz.dart';
import 'package:my_money_v3/core/error/failures.dart';
import 'package:my_money_v3/core/usecase/usecase.dart';
import 'package:my_money_v3/features/report/domain/entities/report_entity.dart';
import 'package:my_money_v3/features/report/domain/repository/report_repository.dart';

class GetReportUseCase implements UseCaseWithoutParam<List<ReportEntity>> {
  final ReportRepository reportRepository;
  GetReportUseCase({required this.reportRepository});

  @override
  Future<Either<Failure, List<ReportEntity>>> call() {
    return reportRepository.getReport();
  }
}
