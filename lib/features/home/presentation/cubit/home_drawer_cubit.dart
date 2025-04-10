import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_backup.dart';

part 'home_drawer_state.dart';

class HomeDrawerCubit extends Cubit<HomeDrawerState> {
  HomeDrawerCubit({
    required this.getBackupUseCase,
  }) : super(HomeDrawerState(loading: false));

  final GetBackup getBackupUseCase;

  Future<void> getBackup() async {
    emit(state.copyWith(loading: true));
    final res = await getBackupUseCase();
    res.fold(
      (failure) {
        emit(state.copyWith(loading: false, error: failure.toString()));
      },
      (success) {
        emit(state.copyWith(loading: false, completed: success));
      },
    );
  }
}
