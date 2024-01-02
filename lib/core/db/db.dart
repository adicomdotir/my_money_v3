import 'package:hive_flutter/hive_flutter.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class DatabaseHelper {
  // late Box<dynamic> _categories;
  // late Box<dynamic> _expenses;

  DatabaseHelper();

  // Future<void> init() async {
  //   _categories = await Hive.openBox('categories');
  //   _expenses = await Hive.openBox('expenses');
  //   print('init complete');
  // }

  Future<String> addCategory(
    Map<String, dynamic> categoryJson,
    String id,
  ) async {
    Box<dynamic> categories = await Hive.openBox('categories');
    await categories.put(id, categoryJson);
    return id;
  }

  Future<List<dynamic>> getCategories() async {
    Box<dynamic> categories = await Hive.openBox('categories');
    return categories.values.toList();
  }

  Future<void> addExpanse(Map<String, dynamic> expenseJson, String id) async {
    Box<dynamic> expenses = await Hive.openBox('expenses');
    return await expenses.put(id, expenseJson);
  }

  Future<void> deleteExpanse(String id) async {
    Box<dynamic> expenses = await Hive.openBox('expenses');
    return await expenses.delete(id);
  }

  Future<bool> deleteCategory(String id) async {
    Box<dynamic> categories = await Hive.openBox('categories');
    Box<dynamic> expenses = await Hive.openBox('expenses');
    bool exsit = expenses.values.any((element) => element['categoryId'] == id);
    if (exsit) return false;
    await categories.delete(id);
    return true;
  }

  Future<List<dynamic>> getExpenses([int? fromDate, int? toDate]) async {
    Box<dynamic> categories = await Hive.openBox('categories');
    Box<dynamic> expenses = await Hive.openBox('expenses');
    Iterable<dynamic> filteredExpenses = fromDate != null
        ? expenses.values.where(
            (elm) => elm['date'] >= fromDate && elm['date'] < toDate,
          )
        : expenses.values;
    for (var element in filteredExpenses) {
      final map = categories.get(element['categoryId']);
      element['category'] = map;
      element['categoryId'] = map['id'];
    }
    final result = filteredExpenses.toList();
    result.sort((a, b) {
      int comp = b['date'] - a['date'];
      if (comp == 0) {
        return int.parse(b['id']) - int.parse(a['id']);
      }
      return comp;
    });
    return result;
  }

  Future<dynamic> getHomeInfo() async {
    Box<dynamic> categories = await Hive.openBox('categories');
    Box<dynamic> expenses = await Hive.openBox('expenses');
    for (var element in expenses.values) {
      final map = categories.get(element['categoryId']);
      element['category'] = map;
    }

    // expense by category
    List<dynamic> list = [];
    Jalali jalali = Jalali.now();
    jalali = jalali.copy(day: 1, hour: 0, minute: 0, second: 0);
    int date = jalali.toDateTime().millisecondsSinceEpoch;
    final result = expenses.values.where((element) => element['date'] >= date);
    for (var category in categories.values) {
      final resultByCategory =
          result.where((item) => item['categoryId'] == category['id']);
      if (resultByCategory.isNotEmpty) {
        final price = resultByCategory
            .map((item) => item['price'])
            .reduce((sum, price) => sum + price);
        list.add({
          'title': category['title'],
          'price': price,
          'color': category['color'],
        });
      }
    }

    // today expense
    jalali = Jalali.now();
    jalali = jalali.copy(hour: 0, minute: 0, second: 0);
    int todayDate = jalali.toDateTime().millisecondsSinceEpoch;
    final todayResult =
        expenses.values.where((element) => element['date'] >= todayDate);
    int todayPrice = 0;
    if (todayResult.isNotEmpty) {
      todayPrice = todayResult
          .map((e) => e['price'])
          .reduce((sum, price) => sum + price);
    }

    // month expense
    jalali = Jalali.now();
    jalali = jalali.copy(day: 1, hour: 0, minute: 0, second: 0);
    int monthDate = jalali.toDateTime().millisecondsSinceEpoch;
    final monthResult =
        expenses.values.where((element) => element['date'] >= monthDate);
    int monthPrice = 0;
    if (monthResult.isNotEmpty) {
      monthPrice = monthResult
          .map((e) => e['price'])
          .reduce((sum, price) => sum + price);
    }

    // 30 days expense
    DateTime nowDate = DateTime.now().subtract(const Duration(days: 30));
    int thirtyDaysDate = nowDate.millisecondsSinceEpoch;
    final thirtyDaysResult =
        expenses.values.where((element) => element['date'] >= thirtyDaysDate);
    int thirtyDaysPrice = 0;
    if (thirtyDaysResult.isNotEmpty) {
      thirtyDaysPrice = thirtyDaysResult
          .map((e) => e['price'])
          .reduce((sum, price) => sum + price);
    }

    // 3 month expense
    nowDate = DateTime.now().subtract(const Duration(days: 90));
    int threeMonthDate = nowDate.millisecondsSinceEpoch;
    final threeMonthResult =
        expenses.values.where((element) => element['date'] >= threeMonthDate);
    int threeMonthPrice = 0;
    if (threeMonthResult.isNotEmpty) {
      threeMonthPrice = threeMonthResult
          .map((e) => e['price'])
          .reduce((sum, price) => sum + price);
    }

    getReport();

    return {
      'expenseByCategory': list,
      'todayPrice': todayPrice,
      'monthPrice': monthPrice,
      'thirtyDaysPrice': thirtyDaysPrice,
      'ninetyDaysPrice': threeMonthPrice,
    };
  }

  Future<List<Map<String, dynamic>>> getReport() async {
    Box<dynamic> categories = await Hive.openBox('categories');
    Box<dynamic> expenses = await Hive.openBox('expenses');

    var sortedExpenses = expenses.values.toList();
    sortedExpenses.sort((a, b) {
      int comp = b['date'] - a['date'];
      return comp;
    });

    final categoriesMap = {};
    final categoriesColorMap = {};
    for (var category in categories.values) {
      categoriesMap[category['id'].toString()] = category['title'];
      categoriesColorMap[category['id'].toString()] = category['color'];
    }

    List<Map<String, dynamic>> resultList = [];
    for (var expense in sortedExpenses) {
      final jalali = Jalali.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(expense['date']),
      );
      final key = '${jalali.year}/${jalali.month}';
      bool keyExist = false;
      for (var item in resultList) {
        if (item['monthName'] == key) {
          keyExist = true;
          final get = item;
          int count = get['sumPrice'];
          get['sumPrice'] = count + expense['price'];
          final catExpenses = (get['catExpenseList'] as List<dynamic>);
          bool exist = false;
          for (var cExp in catExpenses) {
            if (cExp['id'] == expense['categoryId']) {
              cExp['price'] = cExp['price'] + expense['price'];
              cExp['transactionCount'] = cExp['transactionCount'] + 1;
              exist = true;
            }
          }
          if (exist == false) {
            catExpenses.add({
              'id': expense['categoryId'],
              'title': categoriesMap[expense['categoryId'].toString()],
              'transactionCount': 1,
              'color': categoriesColorMap[expense['categoryId'].toString()],
              'price': expense['price'],
            });
          }
        }
      }
      if (keyExist == false) {
        resultList.add({
          'monthName': key,
          'sumPrice': expense['price'],
          'catExpenseList': [
            {
              'id': expense['categoryId'],
              'title': categoriesMap[expense['categoryId'].toString()],
              'transactionCount': 1,
              'color': categoriesColorMap[expense['categoryId'].toString()],
              'price': expense['price'],
            }
          ],
        });
      }
    }

    // For percent & sort
    for (var item in resultList) {
      final catExpenses = (item['catExpenseList'] as List<dynamic>);
      for (var cExp in catExpenses) {
        cExp['percent'] = cExp['price'] / item['sumPrice'] * 100;
      }
      catExpenses.sort(
        (a, b) {
          return b['price'] - a['price'];
        },
      );
    }
    return resultList;
  }
}
