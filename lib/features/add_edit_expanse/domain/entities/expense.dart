import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String author;
  final int id;
  final String content;
  final String permalink;

  const Expense({
    required this.author,
    required this.id,
    required this.content,
    required this.permalink,
  });

  @override
  List<Object?> get props => [author, id, content, permalink];
}
