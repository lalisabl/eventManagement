import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Createevent extends StatefulWidget {
  @override
  _CreateEventFormState createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<Createevent> {
  final _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat('yyyy-MM-dd');

  String _title = '';
  String _description = '';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String _location = '';
  String _organiserId = '';
  bool _vipTicketsIncluded = false;
  int _normalTickets = 0;
  double _normalPrice = 0.0;
  int _vipTickets = 0;
  double _vipPrice = 0.0;
  int _normalTicketsAvailable = 0;
  int _vipTicketsAvailable = 0;

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final Map<String, dynamic> eventData = {
        'title': _title,
        'description': _description,
        'startDate': _dateFormat.format(_startDate),
        'endDate': _dateFormat.format(_endDate),
        'location': _location,
        'organiserId': _organiserId,
        'vipTicketsIncluded': _vipTicketsIncluded,
        'normalTickets': _normalTickets,
        'normalPrice': _normalPrice,
        'vipTickets': _vipTickets,
        'vipPrice': _vipPrice,
        'normalTicketsAvailable': _normalTicketsAvailable,
        'vipTicketsAvailable': _vipTicketsAvailable,
      };

      final response = await http.post(
        Uri.parse('https://your-api-endpoint.com/events'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(eventData),
      );

      if (response.statusCode == 201) {
        // Successfully created event
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event created successfully')),
        );
      } else {
        // Failed to create event
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create event')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create New Event')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value ?? '';
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Start Date (yyyy-MM-dd)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the start date';
                  }
                  return null;
                },
                onSaved: (value) {
                  _startDate = _dateFormat.parse(value ?? '');
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'End Date (yyyy-MM-dd)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the end date';
                  }
                  return null;
                },
                onSaved: (value) {
                  _endDate = _dateFormat.parse(value ?? '');
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event location';
                  }
                  return null;
                },
                onSaved: (value) {
                  _location = value ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Organiser ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the organiser ID';
                  }
                  return null;
                },
                onSaved: (value) {
                  _organiserId = value ?? '';
                },
              ),
              SwitchListTile(
                title: Text('VIP Tickets Included'),
                value: _vipTicketsIncluded,
                onChanged: (bool value) {
                  setState(() {
                    _vipTicketsIncluded = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Normal Tickets'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of normal tickets';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _normalTickets = int.parse(value ?? '0');
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Normal Ticket Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the normal ticket price';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _normalPrice = double.parse(value ?? '0.0');
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'VIP Tickets'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of VIP tickets';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _vipTickets = int.parse(value ?? '0');
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'VIP Ticket Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the VIP ticket price';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _vipPrice = double.parse(value ?? '0.0');
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Normal Tickets Available'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of available normal tickets';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _normalTicketsAvailable = int.parse(value ?? '0');
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'VIP Tickets Available'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of available VIP tickets';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _vipTicketsAvailable = int.parse(value ?? '0');
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
