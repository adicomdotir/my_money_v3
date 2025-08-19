// Feature-specific utility, not shared utils

import '../domain/entities/report_entity.dart';

class ReportChartMapper {
  ReportChartMapper._();

  static Map<String, double> pieChartDataMapper(
    List<CatExpense> catExpenseList,
  ) {
    final result = <String, double>{};
    for (var catExpense in catExpenseList) {
      result[catExpense.title] = catExpense.percent;
    }
    return result;
  }
}
