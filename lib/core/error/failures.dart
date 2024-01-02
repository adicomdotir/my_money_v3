import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class DatabaseFailure extends Failure {
  final String msg;
  DatabaseFailure(this.msg);

  @override
  List<Object?> get props => [msg];
}
