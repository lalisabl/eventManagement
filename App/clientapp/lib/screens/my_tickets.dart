import 'dart:convert';
import 'package:clientapp/screens/ticket_detail.dart';
import 'package:clientapp/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:clientapp/models/ticket.dart';
import 'package:clientapp/constants/url.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyTicketsScreen extends StatefulWidget {
  @override
  _MyTicketsScreenState createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  final storage = FlutterSecureStorage();
  List<Ticket> tickets = [];
  bool isLoading = true;

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

    setState(() {
      isLoading = false;
    });
  }

  void _launchWebView(String checkoutUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(url: checkoutUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tickets'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : tickets.isEmpty
              ? Center(child: Text('No tickets found'))
              : ListView.builder(
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        title: Text(
                          ticket.type.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text(
                              'Status: ${ticket.status}',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'Price: \$${ticket.price}',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Ticket Code: ${ticket.ticketCode}',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5),
                            Image.network(
                              ticket.eventId.thumbnail,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                        trailing: ticket.status == 'pending'
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                ),
                                onPressed: () {
                                  if (ticket
                                      .transactionId.checkoutUrl.isNotEmpty) {
                                    _launchWebView(
                                        ticket.transactionId.checkoutUrl);
                                  } else {
                                    print('Checkout URL is empty');
                                  }
                                },
                                child: Text(
                                  'Checkout',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TicketDetailScreen(ticket: ticket),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class WebViewScreen extends StatelessWidget {
  final String url;

  WebViewScreen({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: WebViewScreen(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
