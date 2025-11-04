import 'package:equatable/equatable.dart';

class DollarRate extends Equatable {
  final int year; // Jalali year, e.g., 1404
  final int month; // 1..12 (Farvardin=1)
  final int price; // price in Rials (or Toman consistent with app)

  const DollarRate({
    required this.year,
    required this.month,
    required this.price,
  });

  String get id =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}';

  @override
  List<Object?> get props => [year, month, price];
}
