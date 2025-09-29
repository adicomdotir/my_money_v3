import 'package:flutter_test/flutter_test.dart';
import 'package:my_money_v3/core/db/hive_models/category_db_model.dart';
import 'package:my_money_v3/shared/data/models/category_model.dart';

void main() {
  test('CategoryDbModel <-> CategoryModel preserves iconKey', () {
    const model = CategoryModel(
      id: 'c1',
      parentId: 'root',
      title: 'Food',
      color: '#FF0000',
      iconKey: 'ic_food',
    );

    final db = model.toDbModel();
    expect(db.iconKey, 'ic_food');

    final roundtrip = db.toCategoryModel();
    expect(roundtrip.iconKey, 'ic_food');
  });
}
