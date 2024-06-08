import 'dart:convert';
import 'package:organizerapp/constants/url.dart';
import 'package:organizerapp/screens/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:organizerapp/models/Event.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:organizerapp/themes/colors.dart';
import 'package:http/http.dart' as http;

// Import the necessary screens
import 'package:organizerapp/screens/editevent.dart';
import 'package:organizerapp/screens/eventattendance.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
  }

  void _editEvent() {
    // Navigate to EditEventScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventScreen(event: widget.event),
      ),
    );
  }

  void _attendEvent() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventAttendanceScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: 'http://localhost:5000/thumbnails/thumbnail.jpeg',
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16.0),
              Text(
                widget.event.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                'Date: ${widget.event.startDate.toLocal()} - ${widget.event.endDate.toLocal()}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8.0),
              Text(
                'Location: ${widget.event.location}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16.0),
              Text(
                widget.event.description,
                style: TextStyle(fontSize: 16),
              ),

              // Add the new buttons here
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _editEvent,
                    icon: Icon(
                      Icons.edit,
                      color: AppColors.primaryColor,
                    ),
                    label: Text(
                      'Edit Event',
                      style: TextStyle(
                        height: 3.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _attendEvent,
                    icon: Icon(
                      Icons.event_available,
                      color: AppColors.primaryColor,
                    ),
                    label: Text(
                      'Event Attendance',
                      style: TextStyle(
                        height: 3.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
