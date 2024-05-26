import 'package:flutter/material.dart';
import 'package:vendorapp/screens/add_product_screen.dart';
import 'package:vendorapp/themes/colors.dart';

class CreatePackageScreen extends StatefulWidget {
  @override
  _CreatePackageScreenState createState() => _CreatePackageScreenState();
}

class _CreatePackageScreenState extends State<CreatePackageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Handle package creation logic
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Package'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30),
              Text(
                'Create a new package',
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
                            Icons.local_offer,
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
                          return 'Please enter a package price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          AppColors.primaryColor,
                        ),
                      ),
                      child: const Text(
                        'Create Package',
                        style: TextStyle(
                          height: 3.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
