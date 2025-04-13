import 'dart:convert';

import 'package:my_money_v3/core/utils/app_strings.dart';
import 'package:my_money_v3/shared/data/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsDataSource {
  Future<bool> changeMoneyUnit(SettingsModel settingsModel);
  Future<bool> saveUserTheme(int themeId);
}

class SettingsDataSourceImpl extends SettingsDataSource {
  final SharedPreferences sharedPreferences;

  SettingsDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> changeMoneyUnit(SettingsModel settingsModel) async {
    if (sharedPreferences.containsKey(AppStrings.settings)) {
      await sharedPreferences.setString(
        AppStrings.settings,
        jsonEncode(settingsModel.toMap()),
      );
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> saveUserTheme(int themeId) async {
    await sharedPreferences.setInt(
      'theme_id',
      themeId,
    );
    return true;
  }
}
