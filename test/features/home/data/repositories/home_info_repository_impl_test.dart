import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_money_v3/core/error/exceptions.dart';
import 'package:my_money_v3/core/error/failures.dart';
import 'package:my_money_v3/features/home/data/datasources/home_info_local_data_source.dart';
import 'package:my_money_v3/features/home/data/models/home_info_model.dart';
import 'package:my_money_v3/features/home/data/repositories/home_info_repository_impl.dart';
import 'package:my_money_v3/features/home/domain/repositories/home_info_repository.dart';

import 'home_info_repository_impl_test.mocks.dart';

@GenerateMocks([HomeInfoLocalDataSource])
void main() {
  late HomeInfoRepository repository;
  late MockHomeInfoLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockHomeInfoLocalDataSource();
    repository =
        HomeInfoRepositoryImpl(homeInfoLocalDataSource: mockLocalDataSource);
  });

  test('getHomeInfo returns HomeInfoEntity when data source call succeeds',
      () async {
    // Arrange
    const mockHomeInfoModel = HomeInfoModel(
      expenseByCategory: [],
      todayPrice: 55000,
      monthPrice: 65000,
      thirtyDaysPrice: 75000,
      ninetyDaysPrice: 95000,
    );
    when(mockLocalDataSource.getHomeInfo())
        .thenAnswer((_) async => mockHomeInfoModel);

    // Act
    final result = await repository.getHomeInfo();

    // Assert
    expect(
      result,
      equals(const Right<Failure, HomeInfoModel>(mockHomeInfoModel)),
    );
    verify(mockLocalDataSource.getHomeInfo()).called(1);
  });

  test('getHomeInfo returns ServerFailure when data source call fails',
      () async {
    // Arrange
    when(mockLocalDataSource.getHomeInfo()).thenThrow(const ServerException());

    // Act
    final result = await repository.getHomeInfo();

    // Assert
    expect(
      result,
      equals(const Left<ServerFailure, dynamic>(ServerFailure())),
    );
    verify(mockLocalDataSource.getHomeInfo()).called(1);
  });
}
