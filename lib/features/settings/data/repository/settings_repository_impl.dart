import 'package:dartz/dartz.dart';
import 'package:my_money_v3/core/error/failures.dart';
import 'package:my_money_v3/features/settings/data/datasource/settings_data_source.dart';
import 'package:my_money_v3/features/settings/domain/repository/settings_repository.dart';
import 'package:my_money_v3/shared/data/models/settings_model.dart';
import 'package:my_money_v3/shared/domain/entities/settings.dart';

class SettingsRepositoryImpl extends SettingsRepository {
  final SettingsDataSource settingsDataSource;

  SettingsRepositoryImpl({required this.settingsDataSource});

  @override
  Future<Either<Failure, bool>> changeMoneyUnit(Settings settings) async {
    try {
      final map = SettingsModel(
        unit: settings.unit,
        locale: settings.locale.languageCode,
        themeId: -1,
      );
      final res = await settingsDataSource.changeMoneyUnit(map);
      return Right(res);
    } on Exception {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveUserTheme(int themeId) async {
    try {
      final res = await settingsDataSource.saveUserTheme(themeId);
      return Right(res);
    } on Exception {
      return Left(CacheFailure());
    }
  }
}
