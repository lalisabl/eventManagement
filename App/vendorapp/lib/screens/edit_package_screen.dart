import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendorapp/constants/url.dart';
import 'package:vendorapp/themes/colors.dart';

class EditPackageScreen extends StatefulWidget {
  final Map<String, dynamic> packageDetails;

  EditPackageScreen({required this.packageDetails});

  @override
  _EditPackageScreenState createState() => _EditPackageScreenState();
}

class _EditPackageScreenState extends State<EditPackageScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  File? _selectedImage;
  bool _isLoading = false;
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.packageDetails['name']);
    _descriptionController =
        TextEditingController(text: widget.packageDetails['description']);
    _priceController =
        TextEditingController(text: widget.packageDetails['price'].toString());

    if (widget.packageDetails['packageImage'] != null) {
      _existingImageUrl =
          '${AppConstants.APIURL.split('/api')[0]}/${widget.packageDetails['packageImage'].replaceAll('\\', '/').replaceFirst('src/public/', '')}';
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _existingImageUrl = null;
        });
      }
    } catch (e) {
      print('An error occurred while picking the image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('An error occurred while picking the image: $e')),
      );
    }
  }

  Future<void> _updatePackage() async {
    if (!_formKey.currentState!.validate()) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse(
            '${AppConstants.APIURL}/package/${widget.packageDetails['_id']}'),
      )
        ..fields['name'] = _nameController.text
        ..fields['description'] = _descriptionController.text
        ..fields['price'] = _priceController.text
        ..headers['Authorization'] = 'Bearer $token';

      if (_selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'packageImage', _selectedImage!.path));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Package updated successfully')),
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Package'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30),
              Text(
                'Edit package',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    if (_selectedImage != null)
                      Image.file(
                        _selectedImage!,
                        height: 150,
                        width: 150,
                      )
                    else if (_existingImageUrl != null)
                      Image.network(
                        _existingImageUrl!,
                        height: 150,
                        width: 150,
                      ),
                    TextButton.icon(
                      icon: Icon(Icons.image),
                      label: Text('Pick Image'),
                      onPressed: _pickImage,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Package Name',
                        filled: true,
                        fillColor: AppColors.primaryColor.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: AppColors.secondaryColor,
                          ),
                          child: Icon(
                            Icons.production_quantity_limits,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a package name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Package Description',
                        filled: true,
                        fillColor: AppColors.primaryColor.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: AppColors.secondaryColor,
                          ),
                          child: Icon(
                            Icons.description,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a package description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Package Price',
                        filled: true,
                        fillColor: AppColors.primaryColor.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: AppColors.secondaryColor,
                          ),
                          child: Icon(
                            Icons.attach_money,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a product price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _updatePackage,
                            child: Text('Update Package'),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
