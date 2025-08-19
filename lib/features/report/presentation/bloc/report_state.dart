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

class ReportLoadingState extends ReportState {}

class ReportSuccessState extends ReportState {
  final List<ReportEntity> reports;
  final bool showPieChart;

  const ReportSuccessState({
    required this.reports,
    required this.showPieChart,
  });

  ReportSuccessState copywith({
    List<ReportEntity>? reports,
    bool? showPieChart,
  }) {
    return ReportSuccessState(
      reports: reports ?? this.reports,
      showPieChart: showPieChart ?? this.showPieChart,
    );
  }

  @override
  List<Object> get props => [reports, showPieChart];
}
