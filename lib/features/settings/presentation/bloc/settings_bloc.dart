import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_money_v3/features/settings/domain/usecases/change_money_unit.dart';
import 'package:my_money_v3/shared/domain/entities/settings.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ChangeMoneyUnit changeMoneyUnit;

  SettingsBloc({required this.changeMoneyUnit}) : super(SettingsInitial()) {
    on<ChangeMoneyUnitEvent>(_changeMoneyUnit);
  }

  void _changeMoneyUnit(
    ChangeMoneyUnitEvent event,
    Emitter<SettingsState> emit,
  ) async {
    print('888888888888888888');
    print(event.settings.locale);
    final result = await changeMoneyUnit.call(event.settings);
    result.fold(
      (error) => null,
      (success) => emit(SettingsSuccess()),
    );
  }
}
