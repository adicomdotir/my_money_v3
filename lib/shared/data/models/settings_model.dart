class SettingsModel {
  final int unit;
  final String locale;
  final int themeId;

  const SettingsModel({
    required this.unit,
    required this.locale,
    required this.themeId,
  });

  factory SettingsModel.fromMap(Map<String, dynamic> json) {
    return SettingsModel(
      unit: json['unit'],
      locale: json['locale'],
      themeId: json['themeId'],
    );
  }

  Map<String, dynamic> toMap() => {
        'unit': unit,
        'locale': locale,
        'themeId': themeId,
      };
}
