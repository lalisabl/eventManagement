import 'package:flutter/material.dart';
import 'package:organizerapp/themes/colors.dart';

class ProfileScreen extends StatelessWidget {
  final String fullName = 'Chaka Tamirat';
  final String email = 'chalatame.com';
  final String phoneNumber = '0902949343';
  final String profileImageUrl = 'https://via.placeholder.com/150'; // Default profile image URL

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
                ),            ),
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

