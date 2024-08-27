part of 'report_bloc.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class ReportErrorState extends ReportState {
  final String message;

  const ReportErrorState({required this.message});
}

class ReportSuccesState extends ReportState {
  final List<ReportEntity> reports;
  final bool showPieChart;

  const ReportSuccesState({
    required this.reports,
    required this.showPieChart,
  });

  ReportSuccesState copywith({
    List<ReportEntity>? reports,
    bool? showPieChart,
  }) {
    return ReportSuccesState(
      reports: reports ?? this.reports,
      showPieChart: showPieChart ?? this.showPieChart,
    );
  }

  @override
  List<Object> get props => [reports, showPieChart];
}
