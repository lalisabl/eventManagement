import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:clientapp/models/ticket.dart';
import 'package:clientapp/constants/url.dart';

class MyTicketsScreen extends StatefulWidget {
  @override
  _MyTicketsScreenState createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  final storage = FlutterSecureStorage();
  List<Ticket> tickets = [];

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  Future<void> _fetchTickets() async {
    final userData = await storage.read(key: 'user');
    if (userData != null) {
      final user = jsonDecode(userData);
      final userId = user['_id'];
      final response =
          await http.get(Uri.parse(AppConstants.APIURL + '/mytickets/$userId'));

      if (response.statusCode == 200) {
        final responseBody = response.body;
        print(responseBody); // Debugging: print the response body
        final List<dynamic> ticketJson = jsonDecode(responseBody);
        setState(() {
          tickets = ticketJson.map((json) => Ticket.fromJson(json)).toList();
        });
      } else {
        print('Failed to load tickets');
      }
    } else {
      print('User not found in storage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tickets'),
      ),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return ListTile(
            title: Text(ticket.type),
            subtitle:
                Text('Status: ${ticket.status}\nPrice: \$${ticket.price}'),
            trailing: Text('Ticket Code: ${ticket.ticketCode}'),
          );
        },
      ),
    );
  }
}
