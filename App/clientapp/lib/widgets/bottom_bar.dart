import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:clientapp/screens/common/profile.dart';
import 'package:clientapp/screens/owner/my_property_list.dart';
import 'package:clientapp/screens/owner/homeScreen.dart';
import 'package:clientapp/screens/common/notification.dart';
import 'package:clientapp/screens/owner/addHouse.dart';
import 'package:clientapp/screens/common/messaging.dart';
import 'package:clientapp/themes/colors.dart';

class OwnerBottomNavigationBar extends StatefulWidget {
  @override
  _OwnerBottomNavigationBarState createState() =>
      _OwnerBottomNavigationBarState();
}

class _OwnerBottomNavigationBarState extends State<OwnerBottomNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    OwnerPropertyListScreen(),
    AddHouseRentScreen(),
     Screen2(),
    // ChattingScreen(),
    // Screen3(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(Icons.home,
              color:
                  _selectedIndex == 0 ? AppColors.secondaryColor : Colors.white,
              size: 30),
          Icon(Icons.history,
              color:
                  _selectedIndex == 1 ? AppColors.secondaryColor : Colors.white,
              size: 30),
          Icon(Icons.add,
              color:
                  _selectedIndex == 2 ? AppColors.secondaryColor : Colors.white,
              size: 30),
          Icon(Icons.message,
              color:
                  _selectedIndex == 3 ? AppColors.secondaryColor : Colors.white,
              size: 30),
          Icon(Icons.person,
              color:
                  _selectedIndex == 4 ? AppColors.secondaryColor : Colors.white,
              size: 30),
        ],
        index: _selectedIndex,
        onTap: _onItemTapped,
        height: 60.0,
        color: AppColors.primaryColor,
        buttonBackgroundColor: AppColors.primaryColor,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
      ),
    );
  }
}
