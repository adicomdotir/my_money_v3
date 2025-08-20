import 'package:dartz/dartz.dart';
import 'package:my_money_v3/lib.dart';

abstract class UseCaseWithParam<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class UseCaseWithoutParam<Type> {
  Future<Either<Failure, Type>> call();
}
