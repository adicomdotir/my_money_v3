import 'package:my_money_v3/features/report/data/model/report_model.dart';

import '../../../../core/db/db.dart';

abstract class ReportDataSource {
  Future<List<ReportModel>> getReport();
}

class ReportDataSourceImpl extends ReportDataSource {
  final DatabaseHelper databaseHelper;

  ReportDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<ReportModel>> getReport() async {
    databaseHelper.getReport();
    return [];
  }
}
