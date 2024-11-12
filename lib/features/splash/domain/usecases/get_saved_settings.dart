import 'package:dartz/dartz.dart';
import 'package:my_money_v3/shared/domain/entities/settings.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/lang_repository.dart';

class GetSavedSettingsUseCase implements UseCaseWithoutParam<Settings> {
  final LangRepository langRepository;

  GetSavedSettingsUseCase({required this.langRepository});

  @override
  Future<Either<Failure, Settings>> call() async =>
      await langRepository.getSavedSettings();
}
