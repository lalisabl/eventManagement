import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:clientapp/themes/colors.dart';
import 'package:clientapp/services/pro_services.dart';  // Import the user data management file

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullName = '';
  String email = '';
  String phoneNumber = '';
  String profileImageUrl = 'https://via.placeholder.com/150'; // Default profile image URL

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    Map<String, String?> userData = await getUserData();
    String? userId = userData['userId'];
    String? token = userData['token'];
print(userData);
    if (userId == null || token == null) {
      // Handle the case where the user is not logged in or data is missing
      print('User ID or token is missing');
      return;
    }

    final response = await http.get(
      Uri.parse('http://127.0.0.1:5000/api/profile'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // debugging
    print('statusCode: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = jsonDecode(response.body);
      setState(() {
        fullName = userData['username'] ?? '';
        email = userData['email'] ?? '';
        phoneNumber = userData['phoneNumber'] ?? 'N/A'; // Assuming phoneNumber is part of the response
        profileImageUrl = userData['profileImageUrl'] ?? 'https://via.placeholder.com/150'; // Assuming profileImageUrl is part of the response
      });
    } else {
      // Handle error
      print('Failed to load user profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 40.0), // Adding padding to move the title down
          child: Center(
            child: Text('My Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        toolbarHeight: 100, // Increase the height of the AppBar to accommodate the padding
      ),
      body: Center( // Centering the entire content
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Centering horizontally
            children: [
              // Profile Image
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profileImageUrl),
              ),
              SizedBox(height: 16),
              // User Full Name
              Text(
                fullName,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 8),
              // Email Label
              Text(
                'Email',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // User Email
              Text(
                email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              // Phone Number Label
              Text(
                'Phone Number',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // User Phone Number
              Text(
                phoneNumber,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              // Edit Profile Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to Edit Profile screen or handle edit profile action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor, // Button background color
                  foregroundColor: Colors.white, // Button text color
                  padding: EdgeInsets.symmetric(horizontal: 82.0, vertical: 12.0), // Adding horizontal padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Reducing border radius
                  ),
                ),
                child: Text('Edit Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
