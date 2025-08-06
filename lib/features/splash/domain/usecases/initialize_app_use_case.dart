import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/splash_repository.dart';

class InitializeAppUseCase implements UseCaseWithoutParam<bool> {
  final SplashRepository splashRepository;

  InitializeAppUseCase({required this.splashRepository});

  @override
  Future<Either<Failure, bool>> call() async {
    return await splashRepository.initializeApp();
  }
}
