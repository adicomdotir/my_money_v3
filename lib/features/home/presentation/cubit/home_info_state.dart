part of 'home_info_cubit.dart';

abstract class HomeInfoState extends Equatable {
  const HomeInfoState();

  @override
  List<Object> get props => [];
}

class HomeInfoInitial extends HomeInfoState {}

class HomeInfoIsLoading extends HomeInfoState {}

class HomeInfoLoaded extends HomeInfoState {
  final HomeInfoEntity homeInfoEntity;

  const HomeInfoLoaded({required this.homeInfoEntity});

  @override
  List<Object> get props => [homeInfoEntity];
}

class HomeInfoError extends HomeInfoState {
  final String msg;

  const HomeInfoError({required this.msg});

  @override
  List<Object> get props => [msg];
}
