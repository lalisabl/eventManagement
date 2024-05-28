import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      // Retrieve the user data
      final userData = await _storage.read(key: 'user');
      if (userData == null) {
        return null;
      }

      // Retrieve the token
      final token = await _storage.read(key: 'token');
      if (token == null) {
        return null;
      }

      // Decode the user data and add the token
      final userMap = jsonDecode(userData) as Map<String, dynamic>;
      userMap['token'] = token;

      return userMap;
    } catch (e) { 
      print('Error reading user data from storage: $e');
      return null;
    }
  }
}
