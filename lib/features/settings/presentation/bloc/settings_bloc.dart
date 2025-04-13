import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/settings/domain/usecases/change_money_unit.dart';
import 'package:my_money_v3/features/settings/domain/usecases/save_user_theme_usecase.dart';
import 'package:my_money_v3/shared/domain/entities/settings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ChangeMoneyUnit changeMoneyUnit;
  final SaveUserThemeUsecase saveUserThemeUsecase;

  SettingsBloc({
    required this.changeMoneyUnit,
    required this.saveUserThemeUsecase,
  }) : super(SettingsInitial()) {
    on<ChangeMoneyUnitEvent>(_changeMoneyUnit);
    on<SaveUserThemeEvent>(_saveUserThemeEvent);
  }

  void _changeMoneyUnit(
    ChangeMoneyUnitEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final result = await changeMoneyUnit.call(event.settings);
    result.fold(
      (error) => null,
      (success) => emit(SettingsSuccess()),
    );
  }

  void _saveUserThemeEvent(
    SaveUserThemeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final result = await saveUserThemeUsecase.call(event.themeId);
    result.fold(
      (error) => null,
      (success) => emit(SettingsSuccess()),
    );
  }
}
