import 'package:my_money_v3/core/db/db.dart';
import 'package:my_money_v3/core/error/exceptions.dart';

import '../../../../shared/data/models/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<String> addEditCategory(CategoryModel categoryModel);
  Future<List<CategoryModel>> getCategories();
  Future<bool> deleteCategory(String id);
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final DatabaseHelper databaseHelper;

  CategoryLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> addEditCategory(CategoryModel categoryModel) async {
    return await databaseHelper.addCategory(
      categoryModel,
    );
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final result = await databaseHelper.getCategories();
    return result;
  }

  @override
  Future<bool> deleteCategory(String id) async {
    final result = await databaseHelper.deleteCategory(id);
    if (result) {
      return true;
    } else {
      throw const DatabaseException(
        'دسته مورد نظر در هزینه ها استفاده شده است و امکان  حذف وجود ندارد',
      );
    }
  }
}
