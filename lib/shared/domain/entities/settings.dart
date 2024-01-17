import 'dart:ui';

import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final int unit;
  final Locale locale;

  const Settings({
    required this.unit,
    required this.locale,
  });

  Settings copyWith({
    int? unit,
    Locale? locale,
  }) {
    return Settings(
      unit: unit ?? this.unit,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [unit, locale];
}
