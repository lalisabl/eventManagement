import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Myprofile extends StatelessWidget {
  Future<String?> getToken() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    //  print('Token: $token'); // Log the token
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while retrieving token
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          // Token is available, show home screen content
          return Center(
            child: Text('my profile'),
          );
        } else {
          // No token found, redirect to login screen
          // Navigator.pushReplacementNamed(context, '/login');
          return Container(); // Placeholder widget, not rendered
        }
      },
    );
  }
}
