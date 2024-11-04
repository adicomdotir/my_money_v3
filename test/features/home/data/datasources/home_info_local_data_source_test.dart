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

  group('getHomeInfo', () {
    final tHomeInfoModel = HomeInfoModel(
      expenseByCategory: [],
      todayPrice: 100,
      monthPrice: 700,
      thirtyDaysPrice: 500,
      ninetyDaysPrice: 3000,
    );

    test(
      'should return HomeInfoModel from Database when call to database is successful',
      () async {
        // arrange
        when(mockDatabaseHelper.getHomeInfo())
            .thenAnswer((_) async => tHomeInfoModel.toMap());
        // act
        final result = await dataSource.getHomeInfo();
        // assert
        verify(mockDatabaseHelper.getHomeInfo());
        expect(result, equals(tHomeInfoModel));
      },
    );
  });
}
