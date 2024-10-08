import 'package:clientapp/screens/event_list.dart';
import 'package:clientapp/screens/favorite_list.dart';
import 'package:clientapp/screens/my_tickets.dart';
import 'package:clientapp/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:clientapp/screens/profile.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    EventsListScreen(),
    FavoritesListScreen(),
    MyTicketsScreen(),
    ProfileScreen(),
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
    Color iconColor =
        isDarkMode ? Colors.white : Color.fromRGBO(40, 40, 43, 1.0);
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(Icons.home, color: iconColor, size: 30),
          Icon(Icons.bookmark, color: iconColor, size: 30),
          Icon(Icons.event, color: iconColor, size: 30),
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
