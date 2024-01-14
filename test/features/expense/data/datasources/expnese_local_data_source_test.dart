import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_money_v3/core/data/models/expense_model.dart';
import 'package:my_money_v3/core/db/db.dart';
import 'package:my_money_v3/features/expense/data/datasources/expnese_local_data_source.dart';

@GenerateNiceMocks([MockSpec<DatabaseHelper>()])
import 'expnese_local_data_source_test.mocks.dart';

void main() {
  late ExpenseLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = ExpenseLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('addExpense', () {
    test('should add an expense to the database', () async {
      // Arrange
      const expenseModel = ExpenseModel(
        id: '1',
        date: 1000000,
        categoryId: '1',
        price: 1000,
        title: '',
      );

      // Act
      await dataSource.addExpense(expenseModel);

      // Assert
      verify(
        mockDatabaseHelper.addExpanse(
          expenseModel.toJson(),
          expenseModel.id,
        ),
      ).called(1);
    });
  });

  group('getExpenses', () {
    test('should return a list of expenses from the database', () async {
      // Arrange
      const fromDate = 1642051200; // Example: January 13, 2022
      const toDate = 1642137600; // Example: January 14, 2022
      final mockExpenses = [
        {
          'id': '1',
          'title': '1',
          'categoryId': '1',
          'date': 1,
          'price': 1,
          'category': {
            'id': '1',
            'parentId': '',
            'title': '',
            'color': '',
          },
        },
        {
          'id': '2',
          'title': '1',
          'categoryId': '1',
          'date': 1,
          'price': 1,
          'category': {
            'id': '1',
            'parentId': '',
            'title': '',
            'color': '',
          },
        },
      ];
      when(mockDatabaseHelper.getExpenses(fromDate, toDate))
          .thenAnswer((_) async => mockExpenses);

      // Act
      final result = await dataSource.getExpenses(fromDate, toDate);

      // Assert
      expect(result.length, equals(2));
      expect(result[0].id, equals('1'));
      expect(result[1].id, equals('2'));
    });
  });

  group('deleteExpense', () {
    test('should delete an expense from the database', () async {
      // Arrange
      const expenseId = '1';

      // Act
      await dataSource.deleteExpense(expenseId);

      // Assert
      verify(mockDatabaseHelper.deleteExpanse(expenseId)).called(1);
    });
  });
}
