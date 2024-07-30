import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendorapp/constants/url.dart';
import 'package:vendorapp/themes/colors.dart';
import 'package:vendorapp/screens/product_detail_screen.dart';

class MyProductsScreen extends StatefulWidget {
  final String? searchQuery;

  MyProductsScreen({this.searchQuery});

  static Function(String)? searchProductsCallback;

  static void searchProducts(String query) {
    if (searchProductsCallback != null) {
      searchProductsCallback!(query);
    }
  }

  @override
  _MyProductsScreenState createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  bool _isLoading = true;
  List _data = [];
  String _searchQuery = "";
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchQuery = widget.searchQuery ?? "";
    _fetchData();
    MyProductsScreen.searchProductsCallback = _onSearchChanged;
  }

  @override
  void didUpdateWidget(covariant MyProductsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      _searchQuery = widget.searchQuery ?? "";
      _fetchData();
    }
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

    try {
      final response = await http.get(
        Uri.parse('${AppConstants.APIURL}/myProduct?q=$_searchQuery'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _data = data['products'];
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
      _fetchData();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

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
                            String? productImage = item['productImage'];
                            if (productImage != null) {
                              productImage = productImage.replaceAll('\\', '/');
                              productImage =
                                  productImage.replaceFirst('src/public/', '');
                            }

                            String imageUrl =
                                '${AppConstants.APIURL.split('/api')[0]}/$productImage';

                            return Card(
                              margin: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 4 / 3.5,
                                    child: (item['productImage'] != null)
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailScreen(
                                                    productId: item['_id']),
                                          ),
                                        );
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
}
