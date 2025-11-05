import 'package:my_money_v3/core/db/db.dart';
import 'package:my_money_v3/core/error/exceptions.dart';

import '../../../../features/dollar_rate/data/models/dollar_rate_model.dart';

abstract class DollarRateLocalDataSource {
  Future<void> upsertDollarRate(DollarRateModel rate);
  Future<DollarRateModel?> getDollarRate(int year, int month);
  Future<List<DollarRateModel>> getAllDollarRates();
  Future<void> deleteDollarRate(int year, int month);
}

class DollarRateLocalDataSourceImpl implements DollarRateLocalDataSource {
  final DatabaseHelper databaseHelper;

  DollarRateLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<void> upsertDollarRate(DollarRateModel rate) async {
    try {
      await databaseHelper.upsertDollarRate(rate);
    } catch (e) {
      throw DatabaseException(
        message: 'خطا در ذخیره نرخ دلار: ${e.toString()}',
      );
    }
  }

  @override
  Future<DollarRateModel?> getDollarRate(int year, int month) async {
    try {
      return await databaseHelper.getDollarRate(year, month);
    } catch (e) {
      throw DatabaseException(
        message: 'خطا در دریافت نرخ دلار: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<DollarRateModel>> getAllDollarRates() async {
    try {
      return await databaseHelper.getAllDollarRates();
    } catch (e) {
      throw DatabaseException(
        message: 'خطا در دریافت لیست نرخ دلار: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> deleteDollarRate(int year, int month) async {
    try {
      await databaseHelper.deleteDollarRate(year, month);
    } catch (e) {
      throw DatabaseException(message: 'خطا در حذف نرخ دلار: ${e.toString()}');
    }
  }
}
