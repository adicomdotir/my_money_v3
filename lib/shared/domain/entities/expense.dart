import 'package:equatable/equatable.dart';
import 'package:my_money_v3/shared/domain/entities/category.dart';

class Expense extends Equatable {
  final String id;
  final String title;
  final int price;
  final int date;
  final String categoryId;
  final Category? category;
  final double usdPrice;

  const Expense({
    required this.id,
    required this.title,
    required this.price,
    required this.date,
    required this.categoryId,
    this.category,
    this.usdPrice = 0,
  });

  @override
  List<Object?> get props => [title, id, date, categoryId, price, usdPrice];
}
