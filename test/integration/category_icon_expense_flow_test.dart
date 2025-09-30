import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:my_money_v3/core/db/db.dart';
import 'package:my_money_v3/core/db/hive_models/category_db_model.dart';
import 'package:my_money_v3/core/db/hive_models/expense_db_model.dart';
import 'package:my_money_v3/shared/data/models/category_model.dart';
import 'package:my_money_v3/shared/data/models/expense_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Category icon integration', () {
    late DatabaseHelper db;

    setUp(() async {
      await setUpTestHive();
      Hive.registerAdapter(CategoryDbModelAdapter());
      Hive.registerAdapter(ExpenseDbModelAdapter());
      db = DatabaseHelper();
    });

    tearDown(() async {
      await tearDownTestHive();
    });

    test('Create category with icon and use in expense', () async {
      const cat = CategoryModel(
        id: 'cat1',
        parentId: '',
        title: 'Food',
        color: '#FF0000',
        iconKey: 'ic_food',
      );

      await db.addCategory(cat);
      final categories = await db.getCategories();
      expect(categories.first.iconKey, 'ic_food');

      final exp = ExpenseModel.fromMap({
        'id': 'e1',
        'title': 'Lunch',
        'price': 10000,
        'date': DateTime.now().millisecondsSinceEpoch,
        'categoryId': 'cat1',
      });
      await db.addExpanse(exp);

      final report = await db.getHomeInfo();
      expect(report['todayPrice'] is int, true);
    });
  });
}
