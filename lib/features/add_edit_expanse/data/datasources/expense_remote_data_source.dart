import 'package:my_money_v3/core/data/models/expense_model.dart';

abstract class ExpenseRemoteDataSource {
  Future<ExpenseModel> getExpense();
}

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  ExpenseRemoteDataSourceImpl();

  @override
  Future<ExpenseModel> getExpense() async {
    // final response = await apiConsumer.get(
    //   EndPoints.randomExpense,
    // );
    return ExpenseModel.fromJson(const {});
  }
}
