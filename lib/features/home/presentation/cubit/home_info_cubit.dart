import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/home/domain/entities/home_info_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/app_strings.dart';
import '../../domain/usecases/get_home_info.dart';

part 'home_info_state.dart';

class HomeInfoCubit extends Cubit<HomeInfoState> {
  final GetHomeInfo getHomeInfoUseCase;

  HomeInfoCubit({
    required this.getHomeInfoUseCase,
  }) : super(HomeInfoInitial());

  Future<void> getHomeInfo() async {
    emit(HomeInfoIsLoading());
    Either<Failure, HomeInfoEntity> response =
        await getHomeInfoUseCase(NoParams());
    emit(
      response.fold(
        (failure) => HomeInfoError(msg: _mapFailureToMsg(failure)),
        (homeInfoEntity) => HomeInfoLoaded(homeInfoEntity: homeInfoEntity),
      ),
    );
  }

  String _mapFailureToMsg(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return AppStrings.serverFailure;
      case CacheFailure:
        return AppStrings.cacheFailure;

      default:
        return AppStrings.unexpectedError;
    }
  }
}
