import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendorapp/constants/url.dart';

class PackageDetailScreen extends StatefulWidget {
  final String packageId;

  PackageDetailScreen({required this.packageId});

  @override
  _PackageDetailScreenState createState() => _PackageDetailScreenState();
}

class _PackageDetailScreenState extends State<PackageDetailScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _packageDetails;

  @override
  void initState() {
    super.initState();
    print(
        'PackageDetailScreen initialized with packageId: ${widget.packageId}');
    _fetchPackageDetails();
  }

  Future<void> _fetchPackageDetails() async {
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
        Uri.parse('${AppConstants.APIURL}/myPackage/${widget.packageId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Fetching package details with packageId: ${widget.packageId}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Package details fetched successfully: $data');
        setState(() {
          _packageDetails =
              data['packagep']; // Correctly parse the 'packagep' key
          _isLoading = false;
        });
      } else {
        final errorMsg = json.decode(response.body)['message'];
        print('Error fetching package details: $errorMsg');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $errorMsg')),
        );
      }
    } catch (e) {
      print('Exception occurred while fetching package details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Package Details'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _packageDetails != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _packageDetails!['packageImage'] != null
                            ? Image.network(
                                '${AppConstants.APIURL.split('/api')[0]}/${_packageDetails!['packageImage'].replaceAll('\\', '/').replaceFirst('src/public/', '')}',
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
                          _packageDetails!['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _packageDetails!['description'],
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0), // Reduce padding
                          child: Text(
                            'Price = ${_packageDetails!['price'].toString()}',
                            style: TextStyle(
                              fontSize: 14, // Adjust font size
                            ),
                          ),
                        ),
                        Text(
                          'Vendor: ${_packageDetails!['vendorId']['username']} (${_packageDetails!['vendorId']['email']})',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Included Services:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...(_packageDetails!['includedServices'] as List)
                            .map((service) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      service['productImage'] != null
                                          ? Image.network(
                                              '${AppConstants.APIURL.split('/api')[0]}/${service['productImage'].replaceAll('\\', '/').replaceFirst('src/public/', '')}',
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              color: Colors.grey,
                                              width: 100,
                                              height: 100,
                                              child: Icon(
                                                Icons.image_not_supported,
                                                size: 50,
                                              ),
                                            ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              service['name'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              service['description'],
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              'Price = ${service['price'].toString()}',
                                              style: TextStyle(
                                                fontSize:
                                                    14, // Adjust font size
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ],
                    ),
                  ),
                )
              : Center(child: Text('Package details not found')),
    );
  }
}
