import 'package:equatable/equatable.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/splash/domain/usecases/get_saved_settings.dart';
import 'package:my_money_v3/shared/domain/entities/settings.dart';

part 'global_event.dart';
part 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  final GetSavedSettingsUseCase getSavedSettingsUseCase;

  GlobalBloc({required this.getSavedSettingsUseCase})
      : super(
          GlobalState(
            settings: Settings(
              unit: 0,
              locale: Locale('fa'),
            ),
            themeData: FlexThemeData.light(
              scheme: FlexScheme.pinkM3,
              fontFamily: 'Vazir',
            ),
          ),
        ) {
    on<ModifyUnitGlobalEvent>((event, emit) {
      emit(
        GlobalState(
          settings: state.settings.copyWith(unit: event.value),
          themeData: FlexThemeData.light(
            scheme: FlexScheme.pinkM3,
            fontFamily: 'Vazir',
          ),
        ),
      );
    });

    on<GetSettingsGlobalEvent>((event, emit) async {
      final result = await getSavedSettingsUseCase.call();
      result.fold(
        (l) => debugPrint(l.toString()),
        (r) => emit(
          GlobalState(
            settings: state.settings.copyWith(unit: r.unit, locale: r.locale),
            themeData: FlexThemeData.light(
              scheme: FlexScheme.pinkM3,
              fontFamily: 'Vazir',
            ),
          ),
        ),
      );
    });

    on<ChangeThemeGlobalEvent>((event, emit) async {
      emit(
        GlobalState(
          settings: state.settings,
          themeData: FlexThemeData.light(
            scheme: event.scheme,
            fontFamily: 'Vazir',
          ),
        ),
      );
    });
  }
}
