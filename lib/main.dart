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

  // generateFakeData();

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

void generateFakeData() {
  final dbh = DatabaseHelper();
  dbh.addCategory(
    const CategoryModel(
      id: '1',
      parentId: '-1',
      title: 'دسته یک',
      color: '#ffff00',
    ).toJson(),
    '1',
  );
  dbh.addCategory(
    const CategoryModel(
      id: '2',
      parentId: '-1',
      title: 'دسته دو',
      color: '#00ffff',
    ).toJson(),
    '2',
  );
  dbh.addCategory(
    const CategoryModel(
      id: '3',
      parentId: '-1',
      title: 'دسته سه',
      color: '#ff00ff',
    ).toJson(),
    '3',
  );
  dbh.addCategory(
    const CategoryModel(
      id: '4',
      parentId: '-1',
      title: 'دسته چهار',
      color: '#ff0000',
    ).toJson(),
    '4',
  );
  dbh.addCategory(
    const CategoryModel(
      id: '5',
      parentId: '-1',
      title: 'دسته پنج',
      color: '#0000ff',
    ).toJson(),
    '5',
  );
  dbh.addCategory(
    const CategoryModel(
      id: '6',
      parentId: '-1',
      title: 'دسته شش',
      color: '#00ff00',
    ).toJson(),
    '6',
  );

  int count = 50000;

  for (var i = 1; i <= count; i++) {
    final rnd = Random().nextInt(6) + 1;
    final price = (Random().nextInt(25) + 1) * count;
    DateTime date = DateTime.now();
    DateTime newDate = date.subtract(Duration(days: count - i));
    dbh.addExpanse(
      ExpenseModel(
        id: i.toString(),
        title: 'هزینه $i',
        price: price,
        date: newDate.millisecondsSinceEpoch,
        categoryId: rnd.toString(),
      ).toJson(),
      i.toString(),
    );
  }
}
