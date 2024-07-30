import 'dart:convert';
import 'package:clientapp/constants/url.dart';
import 'package:clientapp/models/Event.dart';
import 'package:clientapp/screens/authentication/login.dart';
import 'package:clientapp/services/userdata.dart';
import 'package:clientapp/widgets/filter_sort.dart';
import 'package:clientapp/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clientapp/screens/event_detail.dart';
import 'package:intl/intl.dart'; // Import for date formatting

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
  void initState() {
    super.initState();
    isFavorite = widget.event.favorite;
  }

  void toggleFavorite() async {
    final userData = await storage.read(key: 'user');
    if (userData != null) {
      final user = jsonDecode(userData);
      final userId = user['_id'];
      final eventId = widget.event.id;
      final response = await http.post(
        Uri.parse(AppConstants.APIURL + '/favorites'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'eventId': eventId,
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        setState(() {
          isFavorite = true;
        });
      } else if (response.statusCode == 204) {
        setState(() {
          isFavorite = false;
        });
      } else {
        print('Failed to update favorite');
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
      print('User not found in storage');
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date); // Format date
  }

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
                  imageUrl: AppConstants.BASEURL +
                      '/public/thumbnails/thumbnail.jpeg',
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
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.bookmark : Icons.bookmark_add_outlined,
                      color: isFavorite ? Theme.of(context).primaryColor : null,
                    ),
                    onPressed: toggleFavorite,
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
                  Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 4),
                      Text(
                        '${formatDate(widget.event.startDate.toLocal())} - ${formatDate(widget.event.endDate.toLocal())}',
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 4),
                      Text(widget.event.location),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.event_seat),
                      SizedBox(width: 4),
                      Text(
                          'VIP Seats: ${widget.event.vipTicketsAvailable} / ${widget.event.vipTickets}'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.event_seat),
                      SizedBox(width: 4),
                      Text(
                          'Normal Seats: ${widget.event.normalTicketsAvailable} / ${widget.event.normalTickets}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
                      !isDarkMode ? 'assets/day_logo.png' : 'assets/logo.png',
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

  Future<List<Event>> fetchEvents({
    String searchQuery = '',
    String sortOption = '',
    String locationFilter = '',
  }) async {
    final StorageService storageService = StorageService();
    final userData = await storageService.getUserData();
    final userId = userData?['_id'];
    print(userId);
    String url = AppConstants.APIURL + '/events?q=$searchQuery';
    if (sortOption.isNotEmpty) {
      url += '&sort=$sortOption';
    }
    if (locationFilter.isNotEmpty) {
      url += '&location=$locationFilter';
    }
    if (userId != null && userId.isNotEmpty) {
      url += '&userId=$userId';
    }

    print(url);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return (jsonData as List).map((item) => Event.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
}
