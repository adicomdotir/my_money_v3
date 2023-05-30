import '../../data/model/report_model.dart';

class ReportEntity {
  final String monthName;
  final int sumPrice;
  final List<CatExpense> catExpneseList;
  ReportEntity({
    required this.monthName,
    required this.sumPrice,
    required this.catExpneseList,
  });

  ReportEntity copyWith({
    String? monthName,
    int? sumPrice,
    List<CatExpense>? categories,
  }) {
    return ReportEntity(
      monthName: monthName ?? this.monthName,
      sumPrice: sumPrice ?? this.sumPrice,
      catExpneseList: categories ?? catExpneseList,
    );
  }

  static List<ReportEntity> fromModel(List<ReportModel> reports) {
    final reportEntityList = <ReportEntity>[];
    for (var report in reports) {
      final catExpenseList = <CatExpense>[];
      for (var catExpense in report.catExpneseList) {
        catExpenseList
            .add(CatExpense(title: catExpense.title, price: catExpense.price));
      }
      final reportEntity = ReportEntity(
        monthName: report.monthName,
        sumPrice: report.sumPrice,
        catExpneseList: catExpenseList,
      );
      reportEntityList.add(reportEntity);
    }
    return reportEntityList;
  }

  @override
  String toString() =>
      'ReportEnitty(monthName: $monthName, sumPrice: $sumPrice, categories: $catExpneseList)';
}

class CatExpense {
  final String title;
  final int price;
  CatExpense({
    required this.title,
    required this.price,
  });

  CatExpense copyWith({
    String? title,
    int? price,
  }) {
    return CatExpense(
      title: title ?? this.title,
      price: price ?? this.price,
    );
  }

  @override
  String toString() => 'Categorie(title: $title, price: $price)';
}
