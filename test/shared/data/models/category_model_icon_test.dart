import 'package:flutter_test/flutter_test.dart';
import 'package:my_money_v3/shared/data/models/category_model.dart';

void main() {
  group('CategoryModel iconKey', () {
    test('fromMap reads iconKey and toMap writes iconKey', () {
      final map = <String, dynamic>{
        'id': 'cat_1',
        'parentId': 'root',
        'title': 'Food',
        'color': '#FF0000',
        'iconKey': 'ic_food',
      };

      final model = CategoryModel.fromMap(map);

      expect(model.id, 'cat_1');
      expect(model.parentId, 'root');
      expect(model.title, 'Food');
      expect(model.color, '#FF0000');
      expect(model.iconKey, 'ic_food');

      final back = model.toMap();
      expect(back['iconKey'], 'ic_food');
    });

    test('defaults iconKey when missing', () {
      final map = <String, dynamic>{
        'id': 'cat_2',
        'parentId': 'root',
        'title': 'Other',
        'color': '#000000',
      };

      final model = CategoryModel.fromMap(map);
      expect(model.iconKey.isNotEmpty, true);
    });
  });
}
