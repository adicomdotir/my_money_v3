part of 'global_bloc.dart';

class GlobalEvent extends Equatable {
  const GlobalEvent();

  @override
  List<Object> get props => [];
}

class ModifyStateGlobalEvent extends GlobalEvent {
  final int value;

  const ModifyStateGlobalEvent(this.value);

  @override
  List<Object> get props => [value];
}
