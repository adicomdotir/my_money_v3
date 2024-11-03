import 'package:my_money_v3/features/home/data/models/expense_by_category_modal.dart';
import 'package:my_money_v3/features/home/domain/entities/home_info_entity.dart';

class HomeInfoModel extends HomeInfoEntity {
  const HomeInfoModel({
    required List<ExpenseByCategoryModel> super.expenseByCategory,
    required super.todayPrice,
    required super.monthPrice,
    required super.thirtyDaysPrice,
    required super.ninetyDaysPrice,
  });

  factory HomeInfoModel.fromJson(Map<String, dynamic> json) => HomeInfoModel(
        expenseByCategory: List<ExpenseByCategoryModel>.from(
          json['expenseByCategory']
              .map((x) => ExpenseByCategoryModel.fromJson(x)),
        ),
        todayPrice: json['todayPrice'],
        monthPrice: json['monthPrice'],
        thirtyDaysPrice: json['thirtyDaysPrice'],
        ninetyDaysPrice: json['ninetyDaysPrice'],
      );

  Map<String, dynamic> toJson() => {
        'expenseByCategory': List<dynamic>.from(
          (expenseByCategory as List<ExpenseByCategoryModel>)
              .map((x) => x.toJson()),
        ),
        'todayPrice': todayPrice,
        'monthPrice': monthPrice,
        'thirtyDaysPrice': thirtyDaysPrice,
        'ninetyDaysPrice': ninetyDaysPrice,
      };
}
