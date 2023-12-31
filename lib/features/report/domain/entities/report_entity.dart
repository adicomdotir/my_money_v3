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
        catExpenseList.add(
          CatExpense(
            title: catExpense.title,
            price: catExpense.price,
            transactionCount: catExpense.transactionCount,
            percent: catExpense.percent,
            color: catExpense.color,
          ),
        );
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
  final int transactionCount;
  final double percent;
  final String color;

  CatExpense({
    required this.title,
    required this.price,
    required this.transactionCount,
    required this.percent,
    required this.color,
  });

  CatExpense copyWith({
    String? title,
    int? price,
    int? transactionCount,
    double? percent,
    String? color,
  }) {
    return CatExpense(
      title: title ?? this.title,
      price: price ?? this.price,
      transactionCount: transactionCount ?? this.transactionCount,
      percent: percent ?? this.percent,
      color: color ?? this.color,
    );
  }

  @override
  String toString() =>
      'Categorie(title: $title, price: $price, transactionCount: $transactionCount, percent: $percent, color: $color)';
}
