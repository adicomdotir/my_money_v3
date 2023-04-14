import 'package:flutter_test/flutter_test.dart';
import 'package:my_money_v3/features/home/data/models/expense_by_category_modal.dart';
import 'package:my_money_v3/features/home/data/models/home_info_model.dart';

void main() {
  const title1 = 'Food';
  const price1 = 200000;
  const color1 = '#FFA500';
  const title2 = 'Housing';
  const price2 = 500000;
  const color2 = '#008000';

  group('HomeInfoModel', () {
    test('fromJson should return a valid HomeInfoModel instance', () {
      // Arrange
      final json = {
        'expenseByCategory': [
          {
            'title': title1,
            'price': price1,
            'color': color1,
          },
          {
            'title': title2,
            'price': price2,
            'color': color2,
          },
        ],
      };
      const expectedModel = HomeInfoModel(
        expenseByCategory: [
          ExpenseByCategoryModel(
            title: title1,
            price: price1,
            color: color1,
          ),
          ExpenseByCategoryModel(
            title: title2,
            price: price2,
            color: color2,
          ),
        ],
      );

      // Act
      final result = HomeInfoModel.fromJson(json);

      // Assert
      expect(result, expectedModel);
    });

    test('toJson should return a valid JSON object', () {
      // Arrange
      const expense1 = ExpenseByCategoryModel(
        title: title1,
        price: price1,
        color: color1,
      );
      const expense2 = ExpenseByCategoryModel(
        title: title2,
        price: price2,
        color: color2,
      );
      const model = HomeInfoModel(
        expenseByCategory: [expense1, expense2],
      );
      final expectedJson = {
        'expenseByCategory': [
          {
            'title': title1,
            'price': price1,
            'color': color1,
          },
          {
            'title': title2,
            'price': price2,
            'color': color2,
          },
        ],
      };

      // Act
      final result = model.toJson();

      // Assert
      expect(result, expectedJson);
    });
  });
}
