import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/initialize_app_use_case.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final InitializeAppUseCase initializeAppUseCase;

  SplashBloc({
    required this.initializeAppUseCase,
  }) : super(SplashInitial()) {
    on<InitializeAppEvent>(_onInitializeApp);
  }

  Future<void> _onInitializeApp(
    InitializeAppEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());

    // Simulate minimum splash duration
    await Future.delayed(const Duration(milliseconds: 2000));

    final result = await initializeAppUseCase.call();

    result.fold(
      (failure) => emit(SplashError(message: failure.toString())),
      (success) => emit(SplashLoaded()),
    );
  }
}
