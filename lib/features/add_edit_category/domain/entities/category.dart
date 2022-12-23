import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final int parentId;
  final String title;
  final String color;

  const Category({
    required this.id,
    required this.parentId,
    required this.title,
    required this.color,
  });

  @override
  List<Object?> get props => [id, parentId, title, color];
}
