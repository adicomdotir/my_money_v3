import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_money_v3/core/db/hive_models/category_db_model.dart';
import 'package:my_money_v3/core/db/hive_models/expense_db_model.dart';
import 'package:my_money_v3/core/db/migrate_db.dart';

import 'app.dart';
import 'bloc_observer.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize local storage
    await Hive.initFlutter();
    Hive.registerAdapter(CategoryDbModelAdapter());
    Hive.registerAdapter(ExpenseDbModelAdapter());

    // Handle database migrations
    await migrateData();

    // Initialize dependencies
    await di.init();

    // Set up bloc observer
    Bloc.observer = AppBlocObserver();

    runApp(const MyMoneyApp());
  } catch (e) {
    debugPrint('Error during initialization: $e');
    rethrow; // This might crash the app without user feedback
  }
}
