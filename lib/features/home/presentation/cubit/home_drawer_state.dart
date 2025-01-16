part of 'home_drawer_cubit.dart';

class HomeDrawerState extends Equatable {
  const HomeDrawerState({
    required this.loading,
    this.completed = false,
    this.error,
  });

  final bool loading;
  final String? error;
  final bool completed;

  HomeDrawerState copyWith({
    bool? loading,
    String? error,
    bool? completed,
  }) {
    return HomeDrawerState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      completed: completed ?? this.completed,
    );
  }

  @override
  List<Object> get props => [
        loading,
        error ?? '',
        completed,
      ];
}
