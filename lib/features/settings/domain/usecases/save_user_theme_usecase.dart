import 'package:dartz/dartz.dart';
import 'package:my_money_v3/core/error/failures.dart';
import 'package:my_money_v3/core/usecase/usecase.dart';
import 'package:my_money_v3/features/settings/domain/repository/settings_repository.dart';

class SaveUserThemeUsecase extends UseCaseWithParam<bool, int> {
  final SettingsRepository settingsRepository;

  SaveUserThemeUsecase({required this.settingsRepository});

  @override
  Future<Either<Failure, bool>> call(int params) =>
      settingsRepository.saveUserTheme(params);
}
