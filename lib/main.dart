import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_money_v3/core/data/models/category_model.dart';
import 'package:my_money_v3/core/data/models/expense_model.dart';
import 'package:my_money_v3/core/db/db.dart';
import 'app.dart';
import 'bloc_observer.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await di.init();
  Bloc.observer = AppBlocObserver();

  runApp(const MyMoneyApp());
}
