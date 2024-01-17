part of 'global_bloc.dart';

class GlobalEvent extends Equatable {
  const GlobalEvent();

  @override
  List<Object> get props => [];
}

class ModifyUnitGlobalEvent extends GlobalEvent {
  final int value;

  const ModifyUnitGlobalEvent(this.value);

  @override
  List<Object> get props => [value];
}

class GetSettingsGlobalEvent extends GlobalEvent {}
