import 'package:dartz/dartz.dart';
import 'package:my_money_v3/core/error/failures.dart';
import 'package:my_money_v3/core/usecase/usecase.dart';
import 'package:my_money_v3/features/settings/domain/repository/settings_repository.dart';
import 'package:my_money_v3/shared/domain/entities/settings.dart';

class ChangeMoneyUnit extends UseCaseWithParam<bool, Settings> {
  final SettingsRepository settingsRepository;

  ChangeMoneyUnit({required this.settingsRepository});

  @override
  Future<Either<Failure, bool>> call(Settings params) =>
      settingsRepository.changeMoneyUnit(params);
}
