part of 'dollar_rate_cubit.dart';

abstract class DollarRateState extends Equatable {
  const DollarRateState();

  @override
  List<Object?> get props => [];
}

class DollarRateInitial extends DollarRateState {}

class DollarRateLoading extends DollarRateState {}

class DollarRateLoaded extends DollarRateState {
  final List<DollarRate> rates;

  const DollarRateLoaded({required this.rates});

  @override
  List<Object?> get props => [rates];
}

class DollarRateError extends DollarRateState {
  final String message;

  const DollarRateError({required this.message});

  @override
  List<Object?> get props => [message];
}

class DollarRateSuccess extends DollarRateState {}
