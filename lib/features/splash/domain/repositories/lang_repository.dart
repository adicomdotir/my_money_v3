import 'package:dartz/dartz.dart';
import 'package:my_money_v3/shared/domain/entities/settings.dart';

import '../../../../core/error/failures.dart';

abstract class LangRepository {
  Future<Either<Failure, bool>> changeLang({required String langCode});
  Future<Either<Failure, String>> getSavedLang();
  Future<Either<Failure, Settings>> getSavedSettings();
}
