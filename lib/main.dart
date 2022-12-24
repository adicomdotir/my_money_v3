import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'bloc_observer.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await di.init();

  BlocOverrides.runZoned(
    () {
      runApp(const MyMoneyApp());
    },
    blocObserver: AppBlocObserver(),
  );
}
