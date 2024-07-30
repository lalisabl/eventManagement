import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendorapp/constants/url.dart';
import 'package:vendorapp/themes/colors.dart';
import 'package:vendorapp/screens/edit_product_screen.dart'; // Import the edit product screen

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  ProductDetailScreen({required this.productId});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _productDetails;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
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
        Uri.parse('${AppConstants.APIURL}/myProduct/${widget.productId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _productDetails = data['product'];
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

  Future<void> _deleteProduct() async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmDelete != null && confirmDelete) {
      // Proceed with deletion
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not authenticated')),
        );
        return;
      }

      try {
        final response = await http.delete(
          Uri.parse('${AppConstants.APIURL}/Product/${widget.productId}'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product deleted successfully')),
          );
          Navigator.pop(context);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _productDetails != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _productDetails!['productImage'] != null
                            ? Image.network(
                                '${AppConstants.APIURL.split('/api')[0]}/${_productDetails!['productImage'].replaceAll('\\', '/').replaceFirst('src/public/', '')}',
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.grey,
                                width: double.infinity,
                                height: 200,
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                ),
                              ),
                        SizedBox(height: 16),
                        Text(
                          _productDetails!['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _productDetails!['description'],
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Price: ${_productDetails!['price'].toString()}',
                          style: TextStyle(
                            fontSize: 14, // Adjust font size
                          ),
                        ),
                        Text(
                          'Vendor: ${_productDetails!['vendorId']['username']} (${_productDetails!['vendorId']['email']})',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProductScreen(
                                  productDetails: _productDetails!,
                                ),
                              ),
                            );
                          },
                          child: Text('Edit Product'),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _deleteProduct,
                          child: Text('Delete Product'),
                          style: ElevatedButton.styleFrom(
                              //  primary: Colors.red, // Background color
                              // color:Colors.red,
                              ),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(child: Text('Product details not found')),
    );
  }
}
