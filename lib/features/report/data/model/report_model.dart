import 'dart:convert';

class ReportModel {
  final String monthName;
  final int sumPrice;
  final List<CatExpenseModel> catExpneseList;
  ReportModel({
    required this.monthName,
    required this.sumPrice,
    required this.catExpneseList,
  });

  ReportModel copyWith({
    String? monthName,
    int? sumPrice,
    List<CatExpenseModel>? categories,
  }) {
    return ReportModel(
      monthName: monthName ?? this.monthName,
      sumPrice: sumPrice ?? this.sumPrice,
      catExpneseList: categories ?? catExpneseList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'monthName': monthName,
      'sumPrice': sumPrice,
      'catExpenseList': catExpneseList.map((x) => x.toMap()).toList(),
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      monthName: map['monthName'] as String,
      sumPrice: map['sumPrice'].toInt() as int,
      catExpneseList: List<CatExpenseModel>.from(
        (map['catExpenseList'] as List<Map<String, dynamic>>)
            .map<CatExpenseModel>(
          (x) => CatExpenseModel.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportModel.fromJson(String source) =>
      ReportModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ReportEnitty(monthName: $monthName, sumPrice: $sumPrice, categories: $catExpneseList)';
}

class CatExpenseModel {
  final String title;
  final int price;
  final int transactionCount;
  final double percent;
  final String color;

  CatExpenseModel({
    required this.title,
    required this.price,
    required this.transactionCount,
    required this.percent,
    required this.color,
  });

  CatExpenseModel copyWith({
    String? title,
    int? price,
    int? transactionCount,
    double? percent,
    String? color,
  }) {
    return CatExpenseModel(
      title: title ?? this.title,
      price: price ?? this.price,
      transactionCount: transactionCount ?? this.transactionCount,
      percent: percent ?? this.percent,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'price': price,
      'transactionCount': transactionCount,
      'percent': percent,
      'color': color,
    };
  }

  factory CatExpenseModel.fromMap(Map<String, dynamic> map) {
    return CatExpenseModel(
      title: map['title'] as String,
      price: map['price'].toInt() as int,
      transactionCount: (map['transactionCount'] ?? 0).toInt() as int,
      percent: (map['percent'] ?? 0).toDouble() as double,
      color: (map['color'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CatExpenseModel.fromJson(String source) =>
      CatExpenseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Categorie(title: $title, price: $price)';
}
