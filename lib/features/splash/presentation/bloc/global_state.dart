part of 'global_bloc.dart';

class GlobalState extends Equatable {
  const GlobalState({
    required this.settings,
    required this.themeData,
  });

  final Settings settings;
  final ThemeData themeData;

  @override
  List<Object> get props => [settings, themeData];
}
