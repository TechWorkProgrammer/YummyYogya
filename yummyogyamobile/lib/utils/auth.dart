import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static const String _userKey = "user_data";

  static Future<void> saveUser(Map<String, dynamic> userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonData = jsonEncode(userData);
    await prefs.setString(_userKey, jsonData);
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonData = prefs.getString(_userKey);

    if (jsonData != null) {
      return jsonDecode(jsonData) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<void> deleteUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  static Future<void> updateUser(Map<String, dynamic> updatedData) async {
    await saveUser(updatedData);
  }
}
