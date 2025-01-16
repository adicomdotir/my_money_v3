import 'package:dartz/dartz.dart';
import 'package:my_money_v3/features/home/domain/entities/home_info_entity.dart';

import '../../../../core/error/failures.dart';

abstract class HomeInfoRepository {
  Future<Either<Failure, HomeInfoEntity>> getHomeInfo();
  Future<Either<Failure, bool>> getBackup();
}
