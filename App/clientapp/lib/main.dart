import 'package:clientapp/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:clientapp/screens/screen1.dart';
import 'package:clientapp/screens/screen2.dart';
import 'package:clientapp/screens/screen3.dart';
import 'package:clientapp/screens/screen4.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyBottomNavigationBar(),
        '/screen1': (context) => Screen1(),
        '/screen2': (context) => Screen2(),
        '/screen3': (context) => Screen3(),
        '/screen4': (context) => Screen4(),
      },
    );
  }
}
