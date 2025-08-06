import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/settings_repository.dart';

class ChangeLangUseCase implements UseCaseWithParam<bool, String> {
  final SettingsRepository settingsRepository;

  ChangeLangUseCase({required this.settingsRepository});

  @override
  Future<Either<Failure, bool>> call(String langCode) async =>
      await settingsRepository.changeLang(langCode: langCode);
}
