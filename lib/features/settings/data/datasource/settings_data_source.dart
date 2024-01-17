import 'dart:convert';

import 'package:my_money_v3/core/utils/app_strings.dart';
import 'package:my_money_v3/shared/data/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsDataSource {
  Future<bool> changeMoneyUnit(SettingsModel settingsModel);
}

class SettingsDataSourceImpl extends SettingsDataSource {
  final SharedPreferences sharedPreferences;

  SettingsDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> changeMoneyUnit(SettingsModel settingsModel) async {
    if (sharedPreferences.containsKey(AppStrings.settings)) {
      sharedPreferences.setString(
        AppStrings.settings,
        jsonEncode(settingsModel.toJson()),
      );
      return true;
    } else {
      return false;
    }
  }
}
