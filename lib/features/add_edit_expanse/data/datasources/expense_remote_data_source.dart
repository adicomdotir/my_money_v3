import 'package:my_money_v3/core/data/models/expense_model.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';

abstract class ExpenseRemoteDataSource {
  Future<ExpenseModel> getExpense();
}

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  ApiConsumer apiConsumer;

  ExpenseRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ExpenseModel> getExpense() async {
    // final response = await apiConsumer.get(
    //   EndPoints.randomExpense,
    // );
    return ExpenseModel.fromJson(const {});
  }
}
