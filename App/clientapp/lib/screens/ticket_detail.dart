// lib/screens/ticket_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:clientapp/models/ticket.dart';

class TicketDetailScreen extends StatelessWidget {
  final Ticket ticket;

  const TicketDetailScreen({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Event ID: ${ticket.eventId}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8.0),
            Text('User ID: ${ticket.userId}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8.0),
            Text('Transaction ID: ${ticket.transactionId}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8.0),
            Text('Email: ${ticket.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8.0),
            Text('First Name: ${ticket.firstName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8.0),
            Text('Last Name: ${ticket.lastName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8.0),
            Text('Type: ${ticket.type}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8.0),
            Text('Price: \$${ticket.price}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8.0),
            Text('Status: ${ticket.status}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8.0),
            Text('Ticket Code: ${ticket.ticketCode}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8.0),
            Text('Created At: ${ticket.createdAt}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8.0),
            Text('Updated At: ${ticket.updatedAt}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
