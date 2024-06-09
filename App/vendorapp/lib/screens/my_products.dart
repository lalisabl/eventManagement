import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendorapp/constants/url.dart';
import 'package:vendorapp/themes/colors.dart';
import 'package:vendorapp/screens/product_detail_screen.dart'; // Import the new detail screen

class MyProductsScreen extends StatefulWidget {
  @override
  _MyProductsScreenState createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  bool _isLoading = true;
  List _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
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
        Uri.parse('${AppConstants.APIURL}/myProduct'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _products = data['products'];
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

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        final productImage = (product['productImage'] ?? '')
                            .replaceAll('\\', '/')
                            .replaceFirst('src/public/', '');
                        final imageUrl =
                            '${AppConstants.APIURL.split('/api')[0]}/$productImage';
                        final productName =
                            product['name'] ?? 'No name available';
                        final productDescription = product['description'] ??
                            'No description available';
                        final productPrice = product['price'] != null
                            ? product['price'].toString()
                            : 'No price available';

                        return Card(
                          margin: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 4 /
                                    3.5, // Adjust the aspect ratio as needed
                                child: product['productImage'] != null
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
                                padding:
                                    const EdgeInsets.all(8.0), // Reduce padding
                                child: Text(
                                  productName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16, // Adjust font size
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0), // Reduce padding
                                child: Text(
                                  productDescription,
                                  style: TextStyle(
                                      fontSize: 14), // Adjust font size
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0), // Reduce padding
                                child: Text(
                                  'Price: $productPrice',
                                  style: TextStyle(
                                      fontSize: 14), // Adjust font size
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.all(8.0), // Add padding
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailScreen(
                                                productId: product['_id']),
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
