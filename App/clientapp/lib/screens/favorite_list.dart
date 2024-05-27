import 'dart:convert';

import 'package:clientapp/constants/url.dart';
import 'package:clientapp/models/Event.dart';
import 'package:clientapp/screens/event_list.dart';
import 'package:clientapp/services/userdata.dart';
import 'package:clientapp/widgets/filter_sort.dart';
import 'package:clientapp/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavoritesListScreen extends StatefulWidget {
  @override
  _FavoritesListScreenState createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<FavoritesListScreen> {
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
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Event.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
}
