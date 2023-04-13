import 'package:equatable/equatable.dart';
import 'package:my_money_v3/features/home/domain/entities/expense_by_category_entity.dart';

class HomeInfoEntity extends Equatable {
  final List<ExpenseByCategoryEntity> expenseByCategory;

  const HomeInfoEntity({
    required this.expenseByCategory,
  });

  @override
  List<Object?> get props => [expenseByCategory];
}
