import 'package:clientapp/screens/event_list.dart';
import 'package:clientapp/screens/screen1.dart';
import 'package:clientapp/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:clientapp/screens/screen2.dart';
import 'package:clientapp/screens/screen3.dart';
import 'package:clientapp/screens/screen4.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    EventsListScreen(),
    Screen2(),
    Screen3(),
    Screen4(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check the current theme brightness
    bool isDarkMode = Theme.of(context).brightness == Brightness.light;

    // Set icon colors based on the theme
    Color iconColor = isDarkMode ? Colors.white : Color.fromRGBO(40, 40, 43, 1.0);
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(Icons.home, color: iconColor, size: 30),
          Icon(Icons.add_shopping_cart_sharp, color: iconColor, size: 30),
          Icon(Icons.message, color: iconColor, size: 30),
          Icon(Icons.notifications, color: iconColor, size: 30),
        ],
        index: _selectedIndex,
        onTap: _onItemTapped,
        height: 60.0,
        color: AppColors.primaryColor,
        buttonBackgroundColor: AppColors.primaryColor,
        backgroundColor: Colors.white.withOpacity(0),
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
      ),
    );
  }
}
