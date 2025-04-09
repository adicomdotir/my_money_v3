import 'package:equatable/equatable.dart';

class ExpenseByCategoryEntity extends Equatable {
  final String title;
  final String color;
  final int price;
  final String id;

  const ExpenseByCategoryEntity({
    required this.title,
    required this.color,
    required this.price,
    required this.id,
  });

  @override
  List<Object?> get props => [title, color, price, id];
}
