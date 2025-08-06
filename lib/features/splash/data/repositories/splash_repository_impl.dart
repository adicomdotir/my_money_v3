import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/splash_repository.dart';
import '../datasources/splash_local_data_source.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashLocalDataSource splashLocalDataSource;

  SplashRepositoryImpl({required this.splashLocalDataSource});

  @override
  Future<Either<Failure, bool>> initializeApp() async {
    try {
      // Perform any necessary app initialization here
      // For now, we'll just return success
      await splashLocalDataSource.initializeApp();
      return const Right(true);
    } on Exception {
      return Left(CacheFailure());
    }
  }
}
