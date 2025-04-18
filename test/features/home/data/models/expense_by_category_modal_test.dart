import 'package:flutter_test/flutter_test.dart';
import 'package:my_money_v3/features/home/data/models/expense_by_category_modal.dart';
import 'package:my_money_v3/features/home/domain/entities/expense_by_category_entity.dart';

void main() {
  const title = 'Food';
  const price = 200000;
  const color = '#FFA500';
  const id = '1';

  group('ExpenseByCategoryModel', () {
    test('should create a valid ExpenseByCategoryModel instance', () {
      // Arrange

      // Act
      const result = ExpenseByCategoryModel(
        title: title,
        price: price,
        color: color,
        id: id,
      );

      // Assert
      expect(result, isA<ExpenseByCategoryEntity>());
      expect(result.title, title);
      expect(result.price, price);
      expect(result.color, color);
    });

    test('fromMap should return a valid ExpenseByCategoryModel instance', () {
      // Arrange
      final map = {
        'title': title,
        'price': price,
        'color': color,
        'id': '1',
      };

      // Act
      final result = ExpenseByCategoryModel.fromMap(map);

      // Assert
      expect(result, isA<ExpenseByCategoryModel>());
      expect(result.title, title);
      expect(result.price, price);
      expect(result.color, color);
    });

    test('toMap should return a valid JSON object', () {
      // Arrange
      const model = ExpenseByCategoryModel(
        title: title,
        price: price,
        color: color,
        id: id,
      );

      // Act
      final result = model.toMap();

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['title'], title);
      expect(result['price'], price);
      expect(result['color'], color);
    });
  });
}
