import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:my_money_v3/core/db/db.dart';
import 'package:my_money_v3/core/db/hive_models/dollar_rate_db_model.dart';
import 'package:my_money_v3/features/dollar_rate/data/models/dollar_rate_model.dart';

void main() {
  group('DollarRate DB', () {
    late DatabaseHelper db;

    setUp(() async {
      await setUpTestHive();
      Hive.registerAdapter(DollarRateDbModelAdapter());
      db = DatabaseHelper();
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    test('upsert, read, list, delete', () async {
      const r1 = DollarRateModel(year: 1404, month: 1, price: 65000);
      const r2 = DollarRateModel(year: 1404, month: 2, price: 67000);

      await db.upsertDollarRate(r1);
      await db.upsertDollarRate(r2);

      final got = await db.getDollarRate(1404, 1);
      expect(got?.price, 65000);

      final all = await db.getAllDollarRates();
      expect(all.length, 2);
      expect(all.first.month, 2); // sorted desc by (year, month)

      await db.deleteDollarRate(1404, 1);
      final afterDelete = await db.getDollarRate(1404, 1);
      expect(afterDelete, isNull);
    });
  });
}
