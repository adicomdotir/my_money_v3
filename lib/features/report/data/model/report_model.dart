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
      'categories': catExpneseList.map((x) => x.toMap()).toList(),
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      monthName: map['monthName'] as String,
      sumPrice: map['sumPrice'].toInt() as int,
      catExpneseList: List<CatExpenseModel>.from(
        (map['categories'] as List<int>).map<CatExpenseModel>(
          (x) => CatExpenseModel.fromMap(x as Map<String, dynamic>),
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
  CatExpenseModel({
    required this.title,
    required this.price,
  });

  CatExpenseModel copyWith({
    String? title,
    int? price,
  }) {
    return CatExpenseModel(
      title: title ?? this.title,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'price': price,
    };
  }

  factory CatExpenseModel.fromMap(Map<String, dynamic> map) {
    return CatExpenseModel(
      title: map['title'] as String,
      price: map['price'].toInt() as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CatExpenseModel.fromJson(String source) =>
      CatExpenseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Categorie(title: $title, price: $price)';
}
