import 'dart:convert';
import 'package:clientapp/constants/url.dart';
import 'package:clientapp/screens/authentication/register.dart';
import 'package:clientapp/screens/screen1.dart';
import 'package:clientapp/themes/colors.dart';
import 'package:clientapp/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser(BuildContext context) async {
    try {
      // Get user input
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      print(email + ", " + password);

      // Make the HTTP request
      final response = await http.post(
        Uri.parse('${AppConstants.APIURL}/users/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      // Print response for debugging
      print("status: ${response.statusCode}");
      print("response body: ${response.body}");

      if (response.statusCode == 200) {
        final storage = FlutterSecureStorage();
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        // Ensure the response contains the token and user fields
        if (responseBody.containsKey('token') &&
            responseBody.containsKey('user')) {
          await storage.write(key: 'token', value: responseBody['token']);
          final userJson = jsonEncode(responseBody['user']);
          await storage.write(key: 'user', value: userJson);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyBottomNavigationBar()),
            (Route<dynamic> route) => false,
          );
        } else {
          throw Exception('Missing token or user in response');
        }
      } else {
        // Handle login failure
        _showLoginFailedDialog(context);
      }
    } catch (e) {
      print("Error during login: $e");
      _showLoginFailedDialog(context);
    }
  }

  void _showLoginFailedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Failed'),
        content: Text('Invalid email or password. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.light;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 100),
              Image.asset(
                isDarkMode?'assets/day_logo.png':
                'assets/logo.png',
                height: 120,
                width: 50,
              ),
              Center(
                child: Text(
                  "Login to your account",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
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
                      color: AppColors.secondaryColor,
                    ),
                    child: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
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
                      color: AppColors.secondaryColor,
                    ),
                    child: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => loginUser(context),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    AppColors.primaryColor,
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    height: 3.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      height: 20,
                      thickness: 1,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'or',
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      height: 20,
                      thickness: 1,
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
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: AppColors.secondaryColor),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40), // Additional space for bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
