import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/report/domain/entities/report_entity.dart';
import 'package:my_money_v3/features/report/domain/use_cases/get_report_use_case.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/app_strings.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final GetReportUseCase getReportUseCase;

  ReportBloc({required this.getReportUseCase}) : super(ReportInitial()) {
    on<GetReportEvent>(_getReportEvent);
    on<SwitchTypeCardEvent>(_switchTypeCard);
  }

  FutureOr<void> _getReportEvent(
    GetReportEvent event,
    Emitter<ReportState> emit,
  ) async {
    final result = await getReportUseCase();
    result.fold(
      (error) => emit(ReportErrorState(message: _mapFailureToMsg(error))),
      (success) =>
          emit(ReportSuccesState(reports: success, showPieChart: false)),
    );
  }

  FutureOr<void> _switchTypeCard(
    SwitchTypeCardEvent event,
    Emitter<ReportState> emit,
  ) {
    emit(
      (state as ReportSuccesState).copywith(showPieChart: event.type),
    );
  }

  String _mapFailureToMsg(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return AppStrings.serverFailure;
      case CacheFailure _:
        return AppStrings.cacheFailure;

      default:
        return AppStrings.unexpectedError;
    }
  }
}
