part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class GetReportEvent extends ReportEvent {}

class SwitchTypeCard extends ReportEvent {
  final bool type;
  const SwitchTypeCard(this.type);
}
