import 'package:my_money_v3/features/home/data/models/expense_by_category_modal.dart';
import 'package:my_money_v3/features/home/domain/entities/home_info_entity.dart';

class HomeInfoModel extends HomeInfoEntity {
  const HomeInfoModel({
    required List<ExpenseByCategoryModel> expenseByCategory,
  }) : super(expenseByCategory: expenseByCategory);

  factory HomeInfoModel.fromJson(Map<String, dynamic> json) => HomeInfoModel(
        expenseByCategory:
            ExpenseByCategoryModel.fromJson(json['expenseByCategory']),
      );

  Map<String, dynamic> toJson() => {
        'expenseByCategory': '',
      };
}
