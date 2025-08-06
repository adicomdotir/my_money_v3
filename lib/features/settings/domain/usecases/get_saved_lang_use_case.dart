import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/settings_repository.dart';

class GetSavedLangUseCase implements UseCaseWithoutParam<String> {
  final SettingsRepository settingsRepository;

  GetSavedLangUseCase({required this.settingsRepository});

  @override
  Future<Either<Failure, String>> call() async =>
      await settingsRepository.getSavedLang();
}
