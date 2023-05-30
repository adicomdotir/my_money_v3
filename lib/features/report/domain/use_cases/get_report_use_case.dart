import 'package:dartz/dartz.dart';
import 'package:my_money_v3/core/domain/usecases/usecase.dart';
import 'package:my_money_v3/core/error/failures.dart';
import 'package:my_money_v3/features/report/domain/entities/report_entity.dart';
import 'package:my_money_v3/features/report/domain/repository/report_repository.dart';

class GetReportUseCase implements UseCase<List<ReportEntity>, NoParams> {
  final ReportRepository reportRepository;
  GetReportUseCase({required this.reportRepository});

  @override
  Future<Either<Failure, List<ReportEntity>>> call(NoParams params) {
    return reportRepository.getReport();
  }
}
