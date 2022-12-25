import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final String title;
  final int price;
  final int date;
  final String categoryId;

  const Expense({
    required this.id,
    required this.title,
    required this.price,
    required this.date,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [title, id, date, categoryId];
}
