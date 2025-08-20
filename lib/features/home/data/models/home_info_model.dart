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

  factory HomeInfoModel.fromMap(Map<String, dynamic> map) => HomeInfoModel(
        expenseByCategory: List<ExpenseByCategoryModel>.from(
          (map['expenseByCategory'] as List<dynamic>).map(
            (x) => ExpenseByCategoryModel.fromMap(x as Map<String, dynamic>),
          ),
        ),
        todayPrice: map['todayPrice'] as int,
        monthPrice: map['monthPrice'] as int,
        thirtyDaysPrice: map['thirtyDaysPrice'] as int,
        ninetyDaysPrice: map['ninetyDaysPrice'] as int,
      );

  Map<String, dynamic> toMap() => {
        'expenseByCategory': List<dynamic>.from(
          (expenseByCategory as List<ExpenseByCategoryModel>)
              .map((x) => x.toMap()),
        ),
        'todayPrice': todayPrice,
        'monthPrice': monthPrice,
        'thirtyDaysPrice': thirtyDaysPrice,
        'ninetyDaysPrice': ninetyDaysPrice,
      };
}
