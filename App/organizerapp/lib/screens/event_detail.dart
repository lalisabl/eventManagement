import 'dart:convert';

import 'package:organizerapp/constants/url.dart';
import 'package:organizerapp/screens/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:organizerapp/models/Event.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool isFavorite = false; // Track the favorite status
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
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
              SizedBox(height: 16.0),
              // Favorite button
            ],
          ),
        ),
      ),
    );
  }
}
