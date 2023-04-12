import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_money_v3/core/data/models/category_model.dart';
import 'package:my_money_v3/core/data/models/expense_model.dart';
import 'package:my_money_v3/core/db/db.dart';
import 'package:my_money_v3/core/domain/entities/expense.dart';
import 'app.dart';
import 'bloc_observer.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await di.init();
  Bloc.observer = AppBlocObserver();

  // final dbh = DatabaseHelper();
  // dbh.addCategory(
  //   const CategoryModel(
  //     id: '1',
  //     parentId: '-1',
  //     title: 'دسته یک',
  //     color: '#ffff00',
  //   ).toJson(),
  //   '1',
  // );
  // dbh.addCategory(
  //   const CategoryModel(
  //     id: '2',
  //     parentId: '-1',
  //     title: 'دسته دو',
  //     color: '#00ffff',
  //   ).toJson(),
  //   '2',
  // );
  // dbh.addCategory(
  //   const CategoryModel(
  //     id: '3',
  //     parentId: '-1',
  //     title: 'دسته سه',
  //     color: '#ff00ff',
  //   ).toJson(),
  //   '3',
  // );

  // for (var i = 0; i < 20000; i++) {
  //   final rnd = Random().nextInt(3) + 1;
  //   final price = (Random().nextInt(25) + 1) * 10000;
  //   DateTime date = DateTime.now();
  //   DateTime newDate = date.subtract(Duration(days: 10000 - i));
  //   dbh.addExpanse(
  //     ExpenseModel(
  //       id: i.toString(),
  //       title: 'هزینه $i',
  //       price: price,
  //       date: newDate.millisecondsSinceEpoch,
  //       categoryId: rnd.toString(),
  //     ).toJson(),
  //     i.toString(),
  //   );
  // }

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
