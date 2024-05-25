
import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeUserData(String userId, String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
  await prefs.setString('token', token);
}

Future<Map<String, String?>> getUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
  String? token = prefs.getString('token');
  return {'userId': userId, 'token': token};
}
