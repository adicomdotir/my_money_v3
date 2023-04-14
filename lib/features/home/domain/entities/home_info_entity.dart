import 'package:equatable/equatable.dart';
import 'package:my_money_v3/features/home/domain/entities/expense_by_category_entity.dart';

class HomeInfoEntity extends Equatable {
  final List<ExpenseByCategoryEntity> expenseByCategory;
  final int todayPrice;
  final int monthPrice;
  final int thirtyDaysPrice;
  final int ninetyDaysPrice;

  const HomeInfoEntity({
    required this.expenseByCategory,
    required this.todayPrice,
    required this.monthPrice,
    required this.thirtyDaysPrice,
    required this.ninetyDaysPrice,
  });

  @override
  List<Object?> get props => [
        expenseByCategory,
        todayPrice,
        monthPrice,
        thirtyDaysPrice,
        ninetyDaysPrice,
      ];
}
