import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendorapp/constants/url.dart';
import 'package:vendorapp/themes/colors.dart';
import 'package:vendorapp/screens/package_detail_screen.dart';
import 'package:vendorapp/screens/my_products.dart';

class PackagesScreen extends StatefulWidget {
  @override
  _PackagesScreenState createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  bool _isLoading = true;
  List _data = [];
  String _searchQuery = "";
  Timer? _debounce;
  int _activeTabIndex = 0; // 0 for Packages, 1 for Products
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    String endpoint = _activeTabIndex == 0 ? '/myPackage' : '/myProduct';
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.APIURL}$endpoint?q=$_searchQuery'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _data = _activeTabIndex == 0 ? data['packages'] : data['products'];
          _isLoading = false;
        });
      } else {
        final errorMsg = json.decode(response.body)['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $errorMsg')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query;
        _isLoading = true;
      });
      if (_activeTabIndex == 0) {
        _fetchData();
      } else {
        MyProductsScreen.searchProducts(query);
      }
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = "";
      _searchController.clear();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: Column(
              children: [
                _buildSearchBar(),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom:
                          BorderSide(color: AppColors.primaryColor, width: 2),
                    ),
                  ),
                  child: TabBar(
                    onTap: (index) {
                      setState(() {
                        _activeTabIndex = index;
                        _clearSearch(); // Clear search query and text field when switching tabs
                        _fetchData(); // Fetch data based on active tab
                      });
                    },
                    labelColor: AppColors.primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppColors.primaryColor,
                    indicatorWeight: 4.0,
                    tabs: [
                      Tab(text: 'My Packages'),
                      Tab(text: 'My Products'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildListView(screenHeight),
            MyProductsScreen(
                searchQuery:
                    _searchQuery), // Pass search query to MyProductsScreen
          ],
        ),
      ),
    );
  }

  Widget _buildListView(double screenHeight) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : _data.isEmpty
            ? Center(child: Text('Oops, no results found'))
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _data.length,
                          itemBuilder: (context, index) {
                            final item = _data[index];
                            String imageUrl = "";
                            if (_activeTabIndex == 0) {
                              String? packageImage = item['packageImage'];
                              if (packageImage != null) {
                                packageImage =
                                    packageImage.replaceAll('\\', '/');
                                packageImage = packageImage.replaceFirst(
                                    'src/public/', '');
                                imageUrl =
                                    '${AppConstants.APIURL.split('/api')[0]}/$packageImage';
                              }
                            } else {
                              String? productImage = item['productImage'];
                              if (productImage != null) {
                                productImage =
                                    productImage.replaceAll('\\', '/');
                                productImage = productImage.replaceFirst(
                                    'src/public/', '');
                                imageUrl =
                                    '${AppConstants.APIURL.split('/api')[0]}/$productImage';
                              }
                            }

                            return Card(
                              margin: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 4 / 3.5,
                                    child: (item['packageImage'] != null ||
                                            item['productImage'] != null)
                                        ? Image.network(
                                            imageUrl,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            color: Colors.grey,
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                            ),
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item['name'] ?? 'N/A',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      item['description'] ?? 'No description',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      'Price = ${item['price']?.toString() ?? 'N/A'}',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_activeTabIndex == 0) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PackageDetailScreen(
                                                      packageId: item['_id']),
                                            ),
                                          );
                                        } else {
                                          // Handle product detail navigation
                                        }
                                      },
                                      child: Text('See Detail'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          labelText:
              _activeTabIndex == 0 ? 'Search Packages' : 'Search Products',
          filled: true,
          fillColor: AppColors.primaryColor.withOpacity(0.3),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
