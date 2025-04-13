part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class ChangeMoneyUnitEvent extends SettingsEvent {
  final Settings settings;

  const ChangeMoneyUnitEvent({required this.settings});
}

class SaveUserThemeEvent extends SettingsEvent {
  final int themeId;

  const SaveUserThemeEvent({required this.themeId});
}
