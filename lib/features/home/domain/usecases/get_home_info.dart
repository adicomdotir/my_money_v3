import 'package:dartz/dartz.dart';
import 'package:my_money_v3/features/home/domain/entities/home_info_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/domain/usecases/usecase.dart';
import '../repositories/quote_repository.dart';

class GetHomeInfo implements UseCase<HomeInfoEntity, NoParams> {
  final HomeInfoRepository quoteRepository;

  GetHomeInfo({required this.quoteRepository});

  @override
  Future<Either<Failure, HomeInfoEntity>> call(NoParams params) =>
      quoteRepository.getHomeInfo();
}
