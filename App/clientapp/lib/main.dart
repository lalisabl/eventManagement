import 'package:clientapp/screens/event_list.dart';
import 'package:clientapp/screens/profile.dart';
import 'package:clientapp/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:clientapp/screens/authentication/login.dart';
import 'package:clientapp/screens/authentication/register.dart';
import 'package:clientapp/widgets/bottom_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator
        } else if (snapshot.hasError || snapshot.data == false) {
          // Token not found or error occurred, navigate to login
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Client App',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: ThemeMode.system,
            initialRoute: '/login',
            routes: {
              '/register': (context) => SignUpScreen(),
              '/login': (context) => LoginScreen(),
            },
          );
        } else {
          // Token found, navigate to home screen
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Client App',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: ThemeMode.system,

            // home: MyBottomNavigationBar(),
            initialRoute: '/',
            routes: {
              '/': (context) => MyBottomNavigationBar(),
              '/eventlist': (context) => EventsListScreen(),
              '/login': (context) => LoginScreen(),
              '/register': (context) => SignUpScreen(),
            
              '/screen4': (context) => ProfileScreen(),
            },
          );
        }
      },
    );
  }

  // Function to check if token exists asynchronously
  Future<bool> checkToken() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    return token != null;
  }
}
