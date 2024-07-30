import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendorapp/themes/colors.dart';
import 'package:vendorapp/services/user_data.dart';  // Import the user data management file

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String firstName = '';
  String lastName = '';
  String username = '';
  String email = '';
  String phoneNumber = '';
  String profileImageUrl = 'https://via.placeholder.com/150'; // Default profile image URL
  bool isEditing = false;
  bool isLoading = false;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

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
        firstName = userData['firstName'] ?? '';
        lastName = userData['lastName'] ?? '';
        username = userData['username'] ?? '';
        email = userData['email'] ?? '';
        phoneNumber = userData['phoneNumber'] ?? 'N/A'; // Assuming phoneNumber is part of the response
        profileImageUrl = userData['profileImageUrl'] ?? 'https://via.placeholder.com/150'; // Assuming profileImageUrl is part of the response

        // Set the initial values for the controllers
        firstNameController.text = firstName;
        lastNameController.text = lastName;
        usernameController.text = username;
        emailController.text = email;
        phoneNumberController.text = phoneNumber;
      });
    } else {
      // Handle error
      print('Failed to load user profile');
    }
  }

  Future<void> saveUserProfile() async {
    setState(() {
      isLoading = true;
    });

    Map<String, String?> userData = await getUserData();
    String? userId = userData['userId'];
    String? token = userData['token'];
    if (userId == null || token == null) {
      // Handle the case where the user is not logged in or data is missing
      print('User ID or token is missing');
      return;
    }

    final response = await http.put(
      Uri.parse('http://127.0.0.1:5000/api/users/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'username': usernameController.text,
        'email': emailController.text,
        'phoneNumber': phoneNumberController.text,
      }),
    );


    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      setState(() {
        firstName = firstNameController.text;
        lastName = lastNameController.text;
        username = usernameController.text;
        email = emailController.text;
        phoneNumber = phoneNumberController.text;
        isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 40.0), // Adding padding to move the title down
          child: Center(
            child: Text(
              'My Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        toolbarHeight: 100, // Increase the height of the AppBar to accommodate the padding
      ),
      body: SingleChildScrollView(
        child: Center( // Centering the entire content
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
                // First Name
                isEditing
                    ? TextField(
                        controller: firstNameController,
                        decoration: InputDecoration(labelText: 'First Name'),
                      )
                    : Text(
                        firstName,
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                SizedBox(height: 8),
                // Last Name
                isEditing
                    ? TextField(
                        controller: lastNameController,
                        decoration: InputDecoration(labelText: 'Last Name'),
                      )
                    : Text(
                        lastName,
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                SizedBox(height: 8),
                // Username Label
                Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // User Username
                isEditing
                    ? TextField(
                        controller: usernameController,
                      )
                    : Text(
                        username,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
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
                isEditing
                    ? TextField(
                        controller: emailController,
                      )
                    : Text(
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
                isEditing
                    ? TextField(
                        controller: phoneNumberController,
                      )
                    : Text(
                        phoneNumber,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                SizedBox(height: 16),
                // Edit Profile Button
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          if (isEditing) {
                            saveUserProfile();
                          } else {
                            setState(() {
                              isEditing = true;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor, // Button background color
                          foregroundColor: Colors.white, // Button text color
                          padding: EdgeInsets.symmetric(horizontal: 82.0, vertical: 12.0), // Adding horizontal padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), // Reducing border radius
                          ),
                        ),
                        child: Text(isEditing ? 'Save Profile' : 'Edit Profile'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
