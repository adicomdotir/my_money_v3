import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../shared/domain/entities/settings.dart';
import '../repository/settings_repository.dart';

class GetSavedSettingsUseCase implements UseCaseWithoutParam<Settings> {
  final SettingsRepository settingsRepository;

  GetSavedSettingsUseCase({required this.settingsRepository});

  @override
  Future<Either<Failure, Settings>> call() async =>
      await settingsRepository.getSavedSettings();
}
