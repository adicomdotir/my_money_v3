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
    try {
      final result = await databaseHelper.getReport();
      final data = <ReportModel>[];
      for (var element in result) {
        final model = ReportModel.fromMap(element);
        data.add(model);
      }
      return data;
    } on Exception catch (e) {
      print(e.toString());
      return [];
    }
  }
}
