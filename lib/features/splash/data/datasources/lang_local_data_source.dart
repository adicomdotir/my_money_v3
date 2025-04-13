import 'dart:convert';

import 'package:my_money_v3/shared/data/models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/app_strings.dart';

abstract class LangLocalDataSource {
  Future<bool> changeLang({required String langCode});
  Future<String> getSavedLang();
  Future<SettingsModel> getSavedSettings();
}

class LangLocalDataSourceImpl implements LangLocalDataSource {
  final SharedPreferences sharedPreferences;

  LangLocalDataSourceImpl({required this.sharedPreferences});
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
