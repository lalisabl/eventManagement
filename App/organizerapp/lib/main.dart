import 'package:flutter/material.dart';
import 'package:organizerapp/screens/authentication/register.dart';
import 'package:organizerapp/widgets/bottom_bar.dart';
import 'package:organizerapp/screens/myevents.dart';
import 'package:organizerapp/screens/profile.dart';
import 'package:organizerapp/screens/packages.dart';
import 'package:organizerapp/screens/createevent.dart';
import 'package:organizerapp/screens/editevent.dart';
import 'package:organizerapp/screens/manageattendant.dart';
import 'package:organizerapp/screens/authentication/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => SignUpScreen(),
          '/myevents': (context) => Myevents(),
          '/createEvent': (context) => Createevent(),
          '/profile': (context) => ProfileScreen(),
          '/home': (context) => OwnerBottomNavigationBar(),
          '/packages': (context) => Packages(),
          '/editevent': (context) => Editevent(),
          '/manageattendant': (context) => Manageattendant(),
        });
  }
}
