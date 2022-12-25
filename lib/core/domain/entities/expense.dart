import 'package:equatable/equatable.dart';
import 'package:my_money_v3/core/domain/entities/category.dart';

class Expense extends Equatable {
  final String id;
  final String title;
  final int price;
  final int date;
  final String categoryId;
  final Category? category;

  const Expense({
    required this.id,
    required this.title,
    required this.price,
    required this.date,
    required this.categoryId,
    this.category,
  });

  @override
  List<Object?> get props => [title, id, date, categoryId, price];
}
