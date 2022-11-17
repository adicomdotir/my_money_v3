import '../../domain/entities/expense.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required String author,
    required int id,
    required String content,
    required String permalink,
  }) : super(author: author, id: id, content: content, permalink: permalink);

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
        author: json['author'],
        id: json['id'],
        content: json['Expense'],
        permalink: json['permalink'],
      );

  Map<String, dynamic> toJson() => {
        'author': author,
        'id': id,
        'Expense': content,
        'permalink': permalink,
      };
}
