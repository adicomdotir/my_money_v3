import 'package:dartz/dartz.dart';
import 'package:my_money_v3/features/home/domain/entities/home_info_entity.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/home_info_repository.dart';
import '../datasources/home_info_local_data_source.dart';

class HomeInfoRepositoryImpl implements HomeInfoRepository {
  final HomeInfoLocalDataSource homeInfoLocalDataSource;

  HomeInfoRepositoryImpl({
    required this.homeInfoLocalDataSource,
  });

  @override
  Future<Either<Failure, HomeInfoEntity>> getHomeInfo() async {
    try {
      final homeInfoModel = await homeInfoLocalDataSource.getHomeInfo();
      return Right(homeInfoModel);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> getBackup() async {
    try {
      final result = await homeInfoLocalDataSource.getBackup();
      if (result) {
        return Right(result);
      } else {
        return Left(
          DatabaseFailure(message: 'don\'t save'),
        );
      }
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
