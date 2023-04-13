import 'dart:convert';

import 'package:my_money_v3/core/db/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/app_strings.dart';
import '../models/home_info_model.dart';

abstract class HomeInfoLocalDataSource {
  Future<HomeInfoModel> getHomeInfo();
}

class HomeInfoLocalDataSourceImpl implements HomeInfoLocalDataSource {
  final DatabaseHelper databaseHelper;

  HomeInfoLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<HomeInfoModel> getHomeInfo() async {
    final result = await databaseHelper.getHomeInfo();
    return HomeInfoModel.fromJson(jsonDecode(jsonEncode(result)));
  }
}
