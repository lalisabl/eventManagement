import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:organizerapp/constants/url.dart';
import 'package:organizerapp/models/Event.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
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
              Positioned(
                top: 8,
                left: 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.white,
                    child: Text(
                      '\$${event.vipPrice.toString()}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(event.description),
                SizedBox(height: 8),
                Text(
                    'Date: ${event.startDate.toLocal()} - ${event.endDate.toLocal()}'),
                SizedBox(height: 8),
                Text('Location: ${event.location}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Myevents extends StatefulWidget {
  @override
  _EventsListScreenState createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<Myevents> {
  late Future<List<Event>> futureEvents;
  @override
  void initState() {
    super.initState();
    futureEvents = fetchEvents();
  }
}
