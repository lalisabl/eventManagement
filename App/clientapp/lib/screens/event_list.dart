import 'dart:convert';
import 'package:clientapp/constants/url.dart';
import 'package:clientapp/models/Event.dart';
import 'package:clientapp/widgets/filter_sort.dart';
import 'package:clientapp/widgets/search_bar.dart';
import 'package:flutter/material.dart';
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

class EventsListScreen extends StatefulWidget {
  @override
  _EventsListScreenState createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  late Future<List<Event>> futureEvents;
  String searchQuery = '';
  String sortOption = '';
  String locationFilter = '';

  @override
  void initState() {
    super.initState();
    futureEvents = fetchEvents();
  }

  void _searchEvents(String query) {
    setState(() {
      searchQuery = query;
      futureEvents = fetchEvents(
          searchQuery: searchQuery,
          sortOption: sortOption,
          locationFilter: locationFilter);
    });
  }

  void _sortEvents(String sort) {
    setState(() {
      sortOption = sort;
      futureEvents = fetchEvents(
          searchQuery: searchQuery,
          sortOption: sortOption,
          locationFilter: locationFilter);
    });
  }

  void _filterEvents(String location) {
    setState(() {
      locationFilter = location;
      futureEvents = fetchEvents(
          searchQuery: searchQuery,
          sortOption: sortOption,
          locationFilter: locationFilter);
    });
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
                      isDarkMode ? 'assets/day_logo.png' : 'assets/logo.png',
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Search_Bar(onSearch: _searchEvents),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            FilterSort(
              locationFilter: locationFilter,
              onSort: _sortEvents,
              onFilter: _filterEvents,
            ),
            SizedBox(height: 8.0),
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

  Future<List<Event>> fetchEvents(
      {String searchQuery = '',
      String sortOption = '',
      String locationFilter = ''}) async {
    String url = AppConstants.APIURL + '/events?q=$searchQuery';
    if (sortOption.isNotEmpty) {
      url += '&sort=$sortOption';
    }
    if (locationFilter.isNotEmpty) {
      url += '&location=$locationFilter';
    }
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