import 'dart:convert';
import 'package:clientapp/constants/url.dart';
import 'package:clientapp/screens/screen1.dart';
import 'package:clientapp/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  String selectedRole = 'renter'; // Default role

  Future<void> signUpUser(BuildContext context) async {
    // Get user input
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmpassword = confirmpasswordController.text.trim();

    // Check if password and confirmed password match
    if (password != confirmpassword) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('password Mismatch'),
          content:
              Text('The passwords entered do not match. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return; // Exit the function early
    }
    // Send POST request to signUp API
    final response = await http.post(
      Uri.parse('${AppConstants.APIURL}/users/create'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'role': selectedRole, // Include the selected role
      }),
    );

    // Log response
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final storage = FlutterSecureStorage();
      await storage.write(
          key: 'token', value: jsonDecode(response.body)['token']);

      // Save the user object locally
      final userJson = jsonEncode(jsonDecode(response.body)['user']);
      await storage.write(key: 'user', value: userJson);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Screen1()),
        (Route<dynamic> route) => false,
      );
    } else {
      // If signUp fails, show error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Signup Failed'),
          content: Text('Invalid email number or password. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo Image
            SizedBox(height: 20),
            Image.asset(
              'assets/day_logo.png',
              height: 120,
              width: 50,
            ),
            Center(
              child: Text(
                "SignUp to your account",
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Bold font weight
                  color: AppColors.primaryColor, // Primary color
                ),
              ),
            ),
            SizedBox(height: 20),
            // email Number Field
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor:
                    AppColors.primaryColor.withOpacity(0.3), // 30% opacity
                border: OutlineInputBorder(
                  borderSide: BorderSide.none, // No border
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color:
                        AppColors.secondaryColor, // Background color for icon
                  ),
                  child: Icon(
                    Icons.email,
                    color: Colors.white, // Icon color
                  ), // email Icon
                ),
              ),
            ),
            SizedBox(height: 20),
            // password Field
            TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'password',
                filled: true,
                fillColor:
                    AppColors.primaryColor.withOpacity(0.3), // 30% opacity
                border: OutlineInputBorder(
                  borderSide: BorderSide.none, // No border
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color:
                        AppColors.secondaryColor, // Background color for icon
                  ),
                  child: Icon(
                    Icons.lock,
                    color: Colors.white, // Icon color
                  ), // Lock Icon
                ),
              ),
            ),
            SizedBox(height: 20),
            // Confirm password Field
            TextFormField(
              controller: confirmpasswordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm password',
                filled: true,
                fillColor: AppColors.primaryColor.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color:
                        AppColors.secondaryColor, // Background color for icon
                  ),
                  child: Icon(
                    Icons.lock,
                    color: Colors.white, // Icon color
                  ), // Lock Icon
                ),
              ),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => signUpUser(context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  AppColors.primaryColor,
                ),
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  height: 3.5,
                  fontWeight: FontWeight.bold, // Bold font wei
                  color: Colors.white, // Primary color
                ),
              ),
            ),
            SizedBox(height: 40),
            // Divider and Or Text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    height: 20,
                    thickness: 2,
                    color: AppColors.primaryColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'or',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    height: 20,
                    thickness: 2,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),

            GestureDetector(
              onTap: () {
                // Handle Google sign-in here
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 8.0),
                      Text(
                        'Continue with ',
                        style: TextStyle(color: AppColors.primaryColor),
                      ),
                      Image.asset(
                        'assets/images/google_icon.png',
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primaryColor,
                  ), // Primary color border
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
