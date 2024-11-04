import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_money_v3/core/db/db.dart';
import 'package:my_money_v3/features/home/data/datasources/home_info_local_data_source.dart';
import 'package:my_money_v3/features/home/data/models/home_info_model.dart';

import 'home_info_local_data_source_test.mocks.dart';

@GenerateMocks([DatabaseHelper])
void main() {
  late HomeInfoLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource =
        HomeInfoLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  test('getHomeInfo returns HomeInfoModel', () async {
    // Arrange
    const mockHomeInfo = HomeInfoModel(
      expenseByCategory: [],
      todayPrice: 55000,
      monthPrice: 65000,
      thirtyDaysPrice: 75000,
      ninetyDaysPrice: 95000,
    );
    when(mockDatabaseHelper.getHomeInfo())
        .thenAnswer((_) async => mockHomeInfo);

    // Act
    final result = await dataSource.getHomeInfo();
    print(result.toString());

    // Assert
    expect(result, equals(mockHomeInfo));
    verify(mockDatabaseHelper.getHomeInfo());
  });
}
