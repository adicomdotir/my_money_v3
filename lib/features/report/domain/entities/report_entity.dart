import '../../data/model/report_model.dart';

class ReportEntity {
  final String monthName;
  final int sumPrice;
  final double sumPriceUsd;
  final List<CatExpense> catExpneseList;
  ReportEntity({
    required this.monthName,
    required this.sumPrice,
    required this.sumPriceUsd,
    required this.catExpneseList,
  });

  ReportEntity copyWith({
    String? monthName,
    int? sumPrice,
    double? sumPriceUsd,
    List<CatExpense>? categories,
  }) {
    return ReportEntity(
      monthName: monthName ?? this.monthName,
      sumPrice: sumPrice ?? this.sumPrice,
      sumPriceUsd: sumPriceUsd ?? this.sumPriceUsd,
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
            usdPrice: catExpense.usdPrice,
            transactionCount: catExpense.transactionCount,
            percent: catExpense.percent,
            color: catExpense.color,
            id: catExpense.id,
          ),
        );
      }
      final reportEntity = ReportEntity(
        monthName: report.monthName,
        sumPrice: report.sumPrice,
        sumPriceUsd: report.sumPriceUsd,
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
  final double usdPrice;
  final int transactionCount;
  final double percent;
  final String color;
  final String id;

  CatExpense({
    required this.title,
    required this.price,
    required this.usdPrice,
    required this.transactionCount,
    required this.percent,
    required this.color,
    required this.id,
  });

  CatExpense copyWith({
    String? title,
    int? price,
    double? usdPrice,
    int? transactionCount,
    double? percent,
    String? color,
    String? id,
  }) {
    return CatExpense(
      title: title ?? this.title,
      price: price ?? this.price,
      usdPrice: usdPrice ?? this.usdPrice,
      transactionCount: transactionCount ?? this.transactionCount,
      percent: percent ?? this.percent,
      color: color ?? this.color,
      id: id ?? this.id,
    );
  }

  @override
  String toString() =>
      'Categorie(title: $title, price: $price, transactionCount: $transactionCount, percent: $percent, color: $color, id: $id)';
}
