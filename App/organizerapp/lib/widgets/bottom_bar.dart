import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:organizerapp/screens/myevents.dart';
import 'package:organizerapp/screens/profile.dart';
import 'package:organizerapp/screens/packages.dart';
import 'package:organizerapp/screens/createevent.dart';
import 'package:organizerapp/themes/colors.dart';
import 'package:http/http.dart' as http;

class OwnerBottomNavigationBar extends StatefulWidget {
  @override
  _OwnerBottomNavigationBarState createState() =>
      _OwnerBottomNavigationBarState();
}

class _OwnerBottomNavigationBarState extends State<OwnerBottomNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Myevents(),
    Createevent(),
    Packages(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _handleMenuSelection(BuildContext context, String value) async {
    switch (value) {
      case 'about':
        showAboutDialog(
          context: context,
          applicationName: 'OrganizerApp',
          applicationVersion: '1.0.0',
          applicationIcon: Icon(Icons.info),
          children: [
            Text('This is a sample app to demonstrate PopupMenuButton.'),
          ],
        );
        break;
      case 'settings':
        // Navigate to settings page or show settings dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Settings Clicked')),
        );
        break;

      case 'logout':
        final response = await http.post(
          Uri.parse('http://127.0.0.1:5000/api/users/logout'),
        );
        print(response);
        if (response.statusCode == 200) {
          final responseBody = json.decode(response.body);
          if (responseBody['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Logged out successfully')),
            );
            // Handle further actions like navigating to login screen if needed
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Logout failed: ${responseBody['message']}')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logout failed: ${response.reasonPhrase}')),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String result) {
              _handleMenuSelection(context, result);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'about',
                child: Text('About'),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        items: <Widget>[
          Icon(Icons.list,
              color:
                  _selectedIndex == 0 ? AppColors.secondaryColor : Colors.white,
              size: 30),
          Icon(Icons.add,
              color:
                  _selectedIndex == 1 ? AppColors.secondaryColor : Colors.white,
              size: 30),
          Icon(Icons.summarize,
              color:
                  _selectedIndex == 2 ? AppColors.secondaryColor : Colors.white,
              size: 30),
          Icon(Icons.person,
              color:
                  _selectedIndex == 3 ? AppColors.secondaryColor : Colors.white,
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
