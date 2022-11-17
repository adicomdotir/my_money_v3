import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/expense_model.dart';

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
