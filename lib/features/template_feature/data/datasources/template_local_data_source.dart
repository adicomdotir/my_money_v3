import 'package:hive_flutter/hive_flutter.dart';

import '../models/template_model.dart';

/// Abstract data source interface
abstract class TemplateLocalDataSource {
  Future<List<TemplateModel>> getTemplateItems({
    DateTime? fromDate,
    DateTime? toDate,
    bool? isActive,
    String? searchQuery,
  });

  Future<TemplateModel> getTemplateItemById(String id);
  Future<void> createTemplateItem(TemplateModel item);
  Future<void> updateTemplateItem(TemplateModel item);
  Future<void> deleteTemplateItem(String id);
  Future<void> createMultipleItems(List<TemplateModel> items);
  Future<bool> itemExists(String id);
  Future<int> getItemsCount({bool? isActive});
  Future<void> clearAllItems();
}

/// Local data source implementation using Hive
class TemplateLocalDataSourceImpl implements TemplateLocalDataSource {
  static const String boxName = 'template_items';

  Future<Box<TemplateModel>> get _box async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<TemplateModel>(boxName);
    }
    return Hive.box<TemplateModel>(boxName);
  }

  @override
  Future<List<TemplateModel>> getTemplateItems({
    DateTime? fromDate,
    DateTime? toDate,
    bool? isActive,
    String? searchQuery,
  }) async {
    final box = await _box;
    var items = box.values.toList();

    // Apply filters
    if (fromDate != null) {
      items = items.where((item) => item.createdAt.isAfter(fromDate)).toList();
    }

    if (toDate != null) {
      items = items.where((item) => item.createdAt.isBefore(toDate)).toList();
    }

    if (isActive != null) {
      items = items.where((item) => item.isActive == isActive).toList();
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      items = items
          .where(
            (item) =>
                item.title.toLowerCase().contains(query) ||
                item.description.toLowerCase().contains(query),
          )
          .toList();
    }

    // Sort by creation date (newest first)
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return items;
  }

  @override
  Future<TemplateModel> getTemplateItemById(String id) async {
    final box = await _box;
    final item = box.get(id);

    if (item == null) {
      throw Exception('Template item with id $id not found');
    }

    return item;
  }

  @override
  Future<void> createTemplateItem(TemplateModel item) async {
    final box = await _box;
    await box.put(item.id, item);
  }

  @override
  Future<void> updateTemplateItem(TemplateModel item) async {
    final box = await _box;

    if (!box.containsKey(item.id)) {
      throw Exception('Cannot update non-existent item with id ${item.id}');
    }

    // Update with new timestamp
    final updatedItem = item.copyWith(updatedAt: DateTime.now());
    await box.put(item.id, updatedItem);
  }

  @override
  Future<void> deleteTemplateItem(String id) async {
    final box = await _box;

    if (!box.containsKey(id)) {
      throw Exception('Cannot delete non-existent item with id $id');
    }

    await box.delete(id);
  }

  @override
  Future<void> createMultipleItems(List<TemplateModel> items) async {
    final box = await _box;
    final Map<String, TemplateModel> itemsMap = {
      for (var item in items) item.id: item,
    };
    await box.putAll(itemsMap);
  }

  @override
  Future<bool> itemExists(String id) async {
    final box = await _box;
    return box.containsKey(id);
  }

  @override
  Future<int> getItemsCount({bool? isActive}) async {
    final box = await _box;

    if (isActive == null) {
      return box.length;
    }

    return box.values.where((item) => item.isActive == isActive).length;
  }

  @override
  Future<void> clearAllItems() async {
    final box = await _box;
    await box.clear();
  }
}
