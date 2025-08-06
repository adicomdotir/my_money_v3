import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/utils.dart';
import '../../../../shared/data/models/settings_model.dart';

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
    if (sharedPreferences.containsKey(AppConstants.settings)) {
      await sharedPreferences.setString(
        AppConstants.settings,
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
      await sharedPreferences.setString(AppConstants.locale, langCode);

  @override
  Future<String> getSavedLang() async =>
      sharedPreferences.containsKey(AppConstants.locale)
          ? sharedPreferences.getString(AppConstants.locale)!
          : AppConstants.englishCode;

  @override
  Future<SettingsModel> getSavedSettings() async {
    int themeId = 1;
    if (sharedPreferences.containsKey('theme_id')) {
      themeId = sharedPreferences.getInt('theme_id') ?? 1;
    }

    if (sharedPreferences.containsKey(AppConstants.settings)) {
      String json = sharedPreferences.getString(AppConstants.settings) ?? '';
      final sm = SettingsModel.fromMap(jsonDecode(json));
      return SettingsModel(unit: sm.unit, locale: sm.locale, themeId: themeId);
    } else {
      const sm = SettingsModel(unit: 0, locale: 'fa', themeId: -1);
      sharedPreferences.setString(
        AppConstants.settings,
        jsonEncode(sm.toMap()),
      );
      return sm;
    }
  }
}
