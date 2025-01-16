import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/home_info_repository.dart';

class GetBackup implements UseCaseWithoutParam<void> {
  final HomeInfoRepository homeInfoRepository;

  GetBackup({required this.homeInfoRepository});

  @override
  Future<Either<Failure, bool>> call() => homeInfoRepository.getBackup();
}
