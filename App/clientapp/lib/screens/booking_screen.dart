import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:clientapp/constants/url.dart';
import 'package:clientapp/models/Event.dart';
import 'package:clientapp/screens/authentication/login.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class BookingScreen extends StatefulWidget {
  final Event event;

  const BookingScreen({Key? key, required this.event}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final storage = FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  String ticketType = 'normal'; // Default ticket type

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final userData = await storage.read(key: 'user');
    if (userData != null) {
      final user = jsonDecode(userData);
      setState(() {
        emailController.text = user['email'] ?? '';
        firstNameController.text = user['firstName'] ?? '';
        lastNameController.text = user['lastName'] ?? '';
      });
    }
  }

  void _bookEvent() async {
    if (_formKey.currentState?.validate() ?? false) {
      final userData = await storage.read(key: 'user');
      if (userData != null) {
        final user = jsonDecode(userData);
        final userId = user['_id'];
        final price = ticketType == 'normal'
            ? widget.event.normalPrice
            : widget.event.vipPrice;

        final response = await http.post(
          Uri.parse(AppConstants.APIURL + '/tickets'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'userId': userId,
            'eventId': widget.event.id,
            'email': emailController.text,
            'firstName': firstNameController.text,
            'lastName': lastNameController.text,
            'type': ticketType,
           // 'price': price,//
          }),
        );
        if (response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          _showCheckoutDialog(responseData['tranx']['checkout_url']);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to book event')),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }
  }

  void _showCheckoutDialog(String checkoutUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Booking Successful'),
        content: Text('Do you want to proceed to payment now?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _launchURL(checkoutUrl);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ListTile(
                  title: Text('Normal Ticket (\$${widget.event.normalPrice})'),
                  leading: Radio<String>(
                    value: 'normal',
                    groupValue: ticketType,
                    onChanged: (value) {
                      setState(() {
                        ticketType = value!;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text('VIP Ticket (\$${widget.event.vipPrice})'),
                  leading: Radio<String>(
                    value: 'VIP',
                    groupValue: ticketType,
                    onChanged: (value) {
                      setState(() {
                        ticketType = value!;
                      });
                    },
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _bookEvent,
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
