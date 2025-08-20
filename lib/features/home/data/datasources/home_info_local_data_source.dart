import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:my_money_v3/core/db/db.dart';
import 'package:path_provider/path_provider.dart';

import '../models/home_info_model.dart';

abstract class HomeInfoLocalDataSource {
  Future<HomeInfoModel> getHomeInfo();
  Future<bool> getBackup();
}

class HomeInfoLocalDataSourceImpl implements HomeInfoLocalDataSource {
  final DatabaseHelper databaseHelper;

  HomeInfoLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<HomeInfoModel> getHomeInfo() async {
    final result = await databaseHelper.getHomeInfo();
    return HomeInfoModel.fromMap(
      jsonDecode(jsonEncode(result)) as Map<String, dynamic>,
    );
  }

  @override
  Future<bool> getBackup() async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    try {
      final res = await databaseHelper.getBackup();
      await createFileInDownloadsFolder(jsonEncode(res));
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}

Future<void> createFileInDownloadsFolder(String msg) async {
  try {
    // Get the Downloads directory path
    Directory? downloadsDirectory = await getExternalStorageDirectory().onError(
      (error, stackTrace) {
        throw Exception(error.toString());
      },
    );

    if (downloadsDirectory != null) {
      // Get the current date and time
      DateTime now = DateTime.now();

      // Format the date and time as a string (e.g., "2023-10-05_14-30-00")
      String formattedDateTime = DateFormat('yyyy-MM-dd_HH-mm-ss').format(now);

      // Define the file path with the formatted date and time as the file name
      String filePath =
          '/storage/emulated/0/Download/my_money_$formattedDateTime.bk';

      // Create the file
      File file = File(filePath);

      // Write content to the file
      await file.writeAsString(msg);

      debugPrint('File created at: $filePath');
    } else {
      debugPrint('Could not access the Downloads directory.');
    }
  } on Exception catch (e) {
    throw Exception(e);
  }
}
