import 'dart:convert';

import 'package:my_money_v3/core/utils/app_strings.dart';
import 'package:my_money_v3/shared/data/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsDataSource {
  Future<bool> changeMoneyUnit(SettingsModel settingsModel);
  Future<bool> saveUserTheme(int themeId);
  Future<bool> changeLang({required String langCode});
  Future<String> getSavedLang();
  Future<SettingsModel> getSavedSettings();
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

  @override
  Future<bool> changeLang({required String langCode}) async =>
      await sharedPreferences.setString(AppStrings.locale, langCode);

  @override
  Future<String> getSavedLang() async =>
      sharedPreferences.containsKey(AppStrings.locale)
          ? sharedPreferences.getString(AppStrings.locale)!
          : AppStrings.englishCode;

  @override
  Future<SettingsModel> getSavedSettings() async {
    int themeId = 1;
    if (sharedPreferences.containsKey('theme_id')) {
      themeId = sharedPreferences.getInt('theme_id') ?? 1;
    }

    if (sharedPreferences.containsKey(AppStrings.settings)) {
      String json = sharedPreferences.getString(AppStrings.settings) ?? '';
      final sm = SettingsModel.fromMap(jsonDecode(json));
      return SettingsModel(unit: sm.unit, locale: sm.locale, themeId: themeId);
    } else {
      const sm = SettingsModel(unit: 0, locale: 'fa', themeId: -1);
      sharedPreferences.setString(AppStrings.settings, jsonEncode(sm.toMap()));
      return sm;
    }
  }
}
