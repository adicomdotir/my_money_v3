import 'package:dartz/dartz.dart';
import 'package:my_money_v3/core/error/failures.dart';
import 'package:my_money_v3/shared/domain/entities/settings.dart';

abstract class SettingsRepository {
  Future<Either<Failure, bool>> changeMoneyUnit(Settings settings);
  Future<Either<Failure, bool>> saveUserTheme(int themeId);
  Future<Either<Failure, bool>> changeLang({required String langCode});
  Future<Either<Failure, String>> getSavedLang();
  Future<Either<Failure, Settings>> getSavedSettings();
}
