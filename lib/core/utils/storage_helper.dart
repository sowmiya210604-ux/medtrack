import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'user_data';
  static const _emailKey = 'pending_email';
  static const _otpKey = 'pending_otp';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);
    return data != null ? jsonDecode(data) : null;
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> savePendingEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  static Future<String?> getPendingEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<void> savePendingOtp(String otp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_otpKey, otp);
  }

  static Future<String?> getPendingOtp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_otpKey);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
