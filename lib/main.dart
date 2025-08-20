import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'injection_container.dart' as di;
import 'lib.dart';

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
