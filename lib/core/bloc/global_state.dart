part of 'global_bloc.dart';

class GlobalState extends Equatable {
  const GlobalState({required this.unitValue});

  final int unitValue;

  GlobalState copyWith({
    int? unitValue,
  }) {
    return GlobalState(
      unitValue: unitValue ?? this.unitValue,
    );
  }

  @override
  List<Object> get props => [unitValue];
}
