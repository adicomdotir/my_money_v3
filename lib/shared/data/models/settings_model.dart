import 'dart:ui';

class SettingsModel {
  final int unit;
  final String locale;

  const SettingsModel({
    required this.unit,
    required this.locale,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      unit: json['unit'],
      locale: json['locale'],
    );
  }

  Map<String, dynamic> toJson() => {
        'unit': unit,
        'locale': locale,
      };
}
