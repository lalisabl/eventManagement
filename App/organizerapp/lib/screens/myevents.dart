import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:organizerapp/constants/url.dart';
import 'package:organizerapp/models/Event.dart';
import 'package:organizerapp/screens/manageattendant.dart';
import 'package:organizerapp/services/user_data.dart';
import 'package:organizerapp/screens/event_detail.dart';

class EventCard extends StatefulWidget {
  final Event event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late bool isFavorite;
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(event: widget.event),
          ),
        );
      },
      child: Card(
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
                        '\$${widget.event.vipPrice.toString()}',
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
                    widget.event.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(widget.event.description),
                  SizedBox(height: 8),
                  Text(
                      'Date: ${widget.event.startDate.toLocal()} - ${widget.event.endDate.toLocal()}'),
                  SizedBox(height: 8),
                  Text('Location: ${widget.event.location}'),
                ],
              ),
            ),
          ],
        ),
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    child: Image.asset(
                      !isDarkMode ? 'assets/day_logo.png' : 'assets/logo.png',
                    ),
                  ),
                  SizedBox(width: 8.0),
                ],
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Event>>(
        future: futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return EventCard(event: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Event>> fetchEvents() async {
    final userData = await getUserData();
    final userId = userData['userId'];
    print(userId);
    String url = AppConstants.APIURL + '/events?userId=$userId';

    print(url);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Event.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
}
