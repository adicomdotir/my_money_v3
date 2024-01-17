import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:my_money_v3/shared/domain/entities/settings.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/lang_repository.dart';
import '../datasources/lang_local_data_source.dart';

class LangRepositoryImpl implements LangRepository {
  final LangLocalDataSource langLocalDataSource;

  LangRepositoryImpl({required this.langLocalDataSource});

  @override
  Future<Either<Failure, bool>> changeLang({required String langCode}) async {
    try {
      final langIsChanged =
          await langLocalDataSource.changeLang(langCode: langCode);
      return Right(langIsChanged);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getSavedLang() async {
    try {
      final langCode = await langLocalDataSource.getSavedLang();
      return Right(langCode);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Settings>> getSavedSettings() async {
    try {
      final settings = await langLocalDataSource.getSavedSettings();
      print(settings.toJson());
      return Right(
        Settings(unit: settings.unit, locale: Locale(settings.locale)),
      );
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
