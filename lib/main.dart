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
  Bloc.observer = AppBlocObserver();

  runApp(const MyMoneyApp());
  // ThemeData lightTheme = ThemeData.light().copyWith(
  //   colorScheme: ColorScheme.light(
  //     primary: Color(0xFF6FCF97),
  //     secondary: Color(0xFFCF6FA7),
  //   ),
  // );

  // runApp(
  //   MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     theme: lightTheme,
  //     home: Scaffold(
  //       appBar: AppBar(
  //         title: Text('Title'),
  //         actions: [
  //           IconButton(
  //             onPressed: () {},
  //             icon: Icon(Icons.settings),
  //           )
  //         ],
  //       ),
  //       floatingActionButton: FloatingActionButton(
  //         child: Icon(Icons.add),
  //         onPressed: () {},
  //       ),
  //       body: Column(
  //         children: [
  //           Text('This text is in the center'),
  //           ElevatedButton(
  //             onPressed: () {},
  //             child: Text('Button'),
  //           ),
  //           ElevatedButton(
  //             onPressed: null,
  //             child: Text('Button'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ),
  // );
}
