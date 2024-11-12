import 'package:dartz/dartz.dart';

import '../error/failures.dart';

abstract class UseCaseWithParam<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class UseCaseWithoutParam<Type> {
  Future<Either<Failure, Type>> call();
}
