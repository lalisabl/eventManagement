import 'dart:convert';
import 'package:organizerapp/constants/url.dart';
import 'package:organizerapp/models/Event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Createevent extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<Createevent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _thumbnailController = TextEditingController();
  final TextEditingController _normalTicketsController =
      TextEditingController();
  final TextEditingController _normalPriceController = TextEditingController();
  final TextEditingController _vipTicketsController = TextEditingController();
  final TextEditingController _vipPriceController = TextEditingController();
  final TextEditingController _organiserIdController = TextEditingController();
  bool _vipTicketsIncluded = false;
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        _startDate != null &&
        _endDate != null) {
      final event = Event(
        title: _titleController.text,
        description: _descriptionController.text,
        startDate: _startDate!,
        endDate: _endDate!,
        thumbnail: _thumbnailController.text,
        location: _locationController.text,
        vipTicketsIncluded: _vipTicketsIncluded,
        normalTickets: int.parse(_normalTicketsController.text),
        normalPrice: double.parse(_normalPriceController.text),
        vipTickets:
            _vipTicketsIncluded ? int.parse(_vipTicketsController.text) : 0,
        vipPrice:
            _vipTicketsIncluded ? double.parse(_vipPriceController.text) : 0.0,
        normalTicketsAvailable: int.parse(_normalTicketsController.text),
        vipTicketsAvailable:
            _vipTicketsIncluded ? int.parse(_vipTicketsController.text) : 0,
        organiserId: _organiserIdController.text,
      );

      final response = await http.post(
        Uri.parse(AppConstants.APIURL + '/events'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(event),
      );

      if (response.statusCode == 201) {
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create event')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _thumbnailController,
                decoration: InputDecoration(labelText: 'Thumbnail URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a thumbnail URL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _normalTicketsController,
                decoration: InputDecoration(labelText: 'Normal Tickets'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of normal tickets';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _normalPriceController,
                decoration: InputDecoration(labelText: 'Normal Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price of normal tickets';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: Text('Include VIP Tickets'),
                value: _vipTicketsIncluded,
                onChanged: (bool value) {
                  setState(() {
                    _vipTicketsIncluded = value;
                  });
                },
              ),
              if (_vipTicketsIncluded) ...[
                TextFormField(
                  controller: _vipTicketsController,
                  decoration: InputDecoration(labelText: 'VIP Tickets'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of VIP tickets';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _vipPriceController,
                  decoration: InputDecoration(labelText: 'VIP Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the price of VIP tickets';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
              ],
              TextFormField(
                controller: _organiserIdController,
                decoration: InputDecoration(labelText: 'Organiser ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the organiser ID';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text(_startDate == null
                    ? 'Start Date'
                    : 'Start Date: ${_startDate!.toLocal()}'.split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _startDate = pickedDate;
                    });
                  }
                },
              ),
              ListTile(
                title: Text(_endDate == null
                    ? 'End Date'
                    : 'End Date: ${_endDate!.toLocal()}'.split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _endDate = pickedDate;
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
