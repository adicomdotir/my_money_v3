part of 'global_bloc.dart';

class GlobalState extends Equatable {
  const GlobalState({required this.settings});

  final Settings settings;

  @override
  List<Object> get props => [settings];
}
