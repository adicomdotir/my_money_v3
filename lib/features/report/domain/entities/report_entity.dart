class ReportEnitty {
  final String monthName;
  final int sumPrice;
  final List<CatExpense> catExpneseList;
  ReportEnitty({
    required this.monthName,
    required this.sumPrice,
    required this.catExpneseList,
  });

  ReportEnitty copyWith({
    String? monthName,
    int? sumPrice,
    List<CatExpense>? categories,
  }) {
    return ReportEnitty(
      monthName: monthName ?? this.monthName,
      sumPrice: sumPrice ?? this.sumPrice,
      catExpneseList: categories ?? catExpneseList,
    );
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
