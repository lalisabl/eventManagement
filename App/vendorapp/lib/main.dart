import 'package:flutter/material.dart';
import 'package:vendorapp/screens/authentication/register.dart';
import 'package:vendorapp/themes/colors.dart';
import 'package:vendorapp/widgets/bottom_bar.dart';
import 'package:vendorapp/screens/mypackages.dart';
import 'package:vendorapp/screens/myprofile.dart';
import 'package:vendorapp/screens/createpackage.dart';
import 'package:vendorapp/screens/authentication/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
       // theme: AppThemes.lightTheme,
        // darkTheme: AppThemes.darkTheme,
        // themeMode: ThemeMode.system,
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => SignUpScreen(),
          '/mypackages': (context) => Mypackages(),
          '/createpackage': (context) => Createpackage(),
          '/myprofile': (context) => ProfileScreen(),
          '/home': (context) => OwnerBottomNavigationBar(),
        });
  }
}
