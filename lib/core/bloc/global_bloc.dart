import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'global_event.dart';
part 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  GlobalBloc() : super(const GlobalState(unitValue: 0)) {
    on<ModifyStateGlobalEvent>((event, emit) {
      emit(state.copyWith(unitValue: event.value));
    });
  }
}
