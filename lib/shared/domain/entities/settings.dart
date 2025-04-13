import 'dart:ui';

import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final int unit;
  final Locale locale;
  final int themeId;

  const Settings({
    required this.unit,
    required this.locale,
    required this.themeId,
  });

  Settings copyWith({
    int? unit,
    Locale? locale,
    int? themeId,
  }) {
    return Settings(
      unit: unit ?? this.unit,
      locale: locale ?? this.locale,
      themeId: themeId ?? this.themeId,
    );
  }

  @override
  List<Object?> get props => [unit, locale, themeId];
}
