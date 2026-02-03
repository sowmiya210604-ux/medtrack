# 🔗 Complete Flutter Frontend ↔ Backend Integration Guide

## Overview

This guide provides **complete, production-ready code** for integrating your Flutter Web app with the Node.js backend.

**Tech Stack:**
- **Frontend**: Flutter Web (Chrome)
- **Backend**: Node.js + Express (6 microservices on ports 3001-3006)
- **Features**: Registration, Login, OTP Verification, Forgot Password, Authenticated APIs

---

## 📋 Prerequisites

### Backend (Already Done ✅)
- All 6 services running on ports 3001-3006
- CORS configured for Flutter Web
- SMTP configured for OTP emails
- Database migrations completed

### Frontend Setup Needed
```bash
# Add required packages to pubspec.yaml
flutter pub add http
flutter pub add shared_preferences
flutter pub add provider  # For state management
```

---

## 🎯 Step 1: API Configuration Layer

Create `lib/core/config/api_config.dart`:

```dart
/// API Configuration for MedTrack Backend
class ApiConfig {
  // Environment flag
  static const bool isProduction = false;
  
  // Base URLs
  static const String _devBaseUrl = 'http://localhost';
  static const String _prodBaseUrl = 'https://api.medtrack.com';
  
  static String get baseUrl => isProduction ? _prodBaseUrl : _devBaseUrl;
  
  // Service URLs with ports
  static String get authUrl => '$baseUrl:3001/api/auth';
  static String get profileUrl => '$baseUrl:3002/api/profile';
  static String get reportUrl => '$baseUrl:3003/api/reports';
  static String get healthAnalysisUrl => '$baseUrl:3004/api/health-analysis';
  static String get historyUrl => '$baseUrl:3005/api/history';
  static String get notificationUrl => '$baseUrl:3006/api/notifications';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Debug mode
  static const bool enableLogging = true;
  
  /// Log API calls in debug mode
  static void log(String message) {
    if (enableLogging) {
      print('🌐 [API] $message');
    }
  }
}
```

---

## 🔧 Step 2: HTTP Client Service

Create `lib/core/services/http_service.dart`:

```dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../utils/storage_helper.dart';

/// Centralized HTTP client for all API calls
class HttpService {
  /// GET request
  static Future<Map<String, dynamic>> get(
    String url, {
    bool requiresAuth = false,
    Map<String, String>? extraHeaders,
  }) async {
    try {
      ApiConfig.log('GET: $url');
      
      final headers = await _buildHeaders(requiresAuth, extraHeaders);
      ApiConfig.log('Headers: $headers');
      
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(ApiConfig.receiveTimeout);
      
      return _handleResponse(response, url);
    } catch (e) {
      return _handleError(e, url);
    }
  }
  
  /// POST request
  static Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
    Map<String, String>? extraHeaders,
  }) async {
    try {
      ApiConfig.log('POST: $url');
      ApiConfig.log('Body: ${_sanitizeBody(body)}');
      
      final headers = await _buildHeaders(requiresAuth, extraHeaders);
      
      final response = await http
          .post(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.receiveTimeout);
      
      return _handleResponse(response, url);
    } catch (e) {
      return _handleError(e, url);
    }
  }
  
  /// PUT request
  static Future<Map<String, dynamic>> put(
    String url,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
    Map<String, String>? extraHeaders,
  }) async {
    try {
      ApiConfig.log('PUT: $url');
      ApiConfig.log('Body: ${_sanitizeBody(body)}');
      
      final headers = await _buildHeaders(requiresAuth, extraHeaders);
      
      final response = await http
          .put(
            Uri.parse(url),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.receiveTimeout);
      
      return _handleResponse(response, url);
    } catch (e) {
      return _handleError(e, url);
    }
  }
  
  /// DELETE request
  static Future<Map<String, dynamic>> delete(
    String url, {
    bool requiresAuth = false,
    Map<String, String>? extraHeaders,
  }) async {
    try {
      ApiConfig.log('DELETE: $url');
      
      final headers = await _buildHeaders(requiresAuth, extraHeaders);
      
      final response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(ApiConfig.receiveTimeout);
      
      return _handleResponse(response, url);
    } catch (e) {
      return _handleError(e, url);
    }
  }
  
  /// Build headers with optional authentication
  static Future<Map<String, String>> _buildHeaders(
    bool requiresAuth,
    Map<String, String>? extraHeaders,
  ) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (requiresAuth) {
      final token = await StorageHelper.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      } else {
        throw Exception('Authentication token not found. Please login again.');
      }
    }
    
    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }
    
    return headers;
  }
  
  /// Handle HTTP response
  static Map<String, dynamic> _handleResponse(
    http.Response response,
    String url,
  ) {
    ApiConfig.log('Response Status: ${response.statusCode}');
    ApiConfig.log('Response Body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...');
    
    if (response.body.isEmpty) {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Empty response from server',
      );
    }
    
    final Map<String, dynamic> data = jsonDecode(response.body);
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: data['message'] ?? 'Request failed',
        errors: data['errors'],
      );
    }
  }
  
  /// Handle errors
  static Map<String, dynamic> _handleError(dynamic error, String url) {
    ApiConfig.log('ERROR: $error');
    
    if (error is ApiException) {
      rethrow;
    }
    
    if (error is SocketException) {
      throw ApiException(
        statusCode: 0,
        message: 'No internet connection. Please check your network.',
      );
    }
    
    if (error is http.ClientException) {
      throw ApiException(
        statusCode: 0,
        message: 'Failed to connect to server. Is the backend running?',
      );
    }
    
    if (error.toString().contains('TimeoutException')) {
      throw ApiException(
        statusCode: 408,
        message: 'Request timeout. Please try again.',
      );
    }
    
    throw ApiException(
      statusCode: 0,
      message: 'An unexpected error occurred: ${error.toString()}',
    );
  }
  
  /// Sanitize request body for logging (hide sensitive data)
  static String _sanitizeBody(Map<String, dynamic> body) {
    final sanitized = Map<String, dynamic>.from(body);
    if (sanitized.containsKey('password')) {
      sanitized['password'] = '***';
    }
    if (sanitized.containsKey('newPassword')) {
      sanitized['newPassword'] = '***';
    }
    return jsonEncode(sanitized);
  }
}

/// Custom API Exception
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic errors;
  
  ApiException({
    required this.statusCode,
    required this.message,
    this.errors,
  });
  
  @override
  String toString() => message;
  
  /// Check if error is authentication related
  bool get isAuthError => statusCode == 401 || statusCode == 403;
  
  /// Check if error is validation related
  bool get isValidationError => statusCode == 400;
  
  /// Check if error is server related
  bool get isServerError => statusCode >= 500;
}
```

---

## 💾 Step 3: Storage Helper

Create `lib/core/utils/storage_helper.dart`:

```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Helper class for local storage operations
class StorageHelper {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _emailKey = 'user_email';
  
  /// Save authentication token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    print('🔐 Token saved');
  }
  
  /// Get authentication token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
  
  /// Save user data
  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
    
    // Save email separately for easy access
    if (user.containsKey('email')) {
      await prefs.setString(_emailKey, user['email']);
    }
    
    print('👤 User data saved: ${user['email']}');
  }
  
  /// Get user data
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    
    if (userJson != null) {
      return jsonDecode(userJson) as Map<String, dynamic>;
    }
    
    return null;
  }
  
  /// Get user email
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }
  
  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
  
  /// Clear all data (logout)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('🚪 User logged out, storage cleared');
  }
  
  /// Save temporary data (like pending OTP email)
  static Future<void> savePendingEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_email', email);
  }
  
  /// Get temporary pending email
  static Future<String?> getPendingEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('pending_email');
  }
  
  /// Clear pending email
  static Future<void> clearPendingEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('pending_email');
  }
}
```

---

## 🔐 Step 4: Authentication Service

Create `lib/core/services/auth_service.dart`:

```dart
import '../config/api_config.dart';
import 'http_service.dart';
import '../utils/storage_helper.dart';

/// Authentication service for all auth-related API calls
class AuthService {
  /// Register a new user
  /// 
  /// Sends registration request and OTP email
  /// Returns userId and email on success
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = '${ApiConfig.authUrl}/register';
    
    final body = {
      'name': name,
      'email': email,
      'password': password,
    };
    
    try {
      final response = await HttpService.post(url, body);
      
      if (response['success'] == true) {
        // Save email for OTP verification step
        await StorageHelper.savePendingEmail(email);
        
        return {
          'success': true,
          'message': response['message'],
          'userId': response['data']['userId'],
          'email': response['data']['email'],
          'expiresAt': response['data']['expiresAt'],
        };
      } else {
        throw ApiException(
          statusCode: 400,
          message: response['message'] ?? 'Registration failed',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
  
  /// Verify OTP code
  /// 
  /// Validates the OTP sent to user's email
  /// Marks account as verified
  static Future<Map<String, dynamic>> verifyOTP({
    required String email,
    required String otpCode,
  }) async {
    final url = '${ApiConfig.authUrl}/verify-otp';
    
    final body = {
      'email': email,
      'otpCode': otpCode,
    };
    
    try {
      final response = await HttpService.post(url, body);
      
      if (response['success'] == true) {
        // Clear pending email after successful verification
        await StorageHelper.clearPendingEmail();
        
        return {
          'success': true,
          'message': response['message'],
          'userId': response['data']['userId'],
          'email': response['data']['email'],
        };
      } else {
        throw ApiException(
          statusCode: 400,
          message: response['message'] ?? 'OTP verification failed',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
  
  /// Resend OTP code
  /// 
  /// Generates and sends a new OTP to user's email
  static Future<Map<String, dynamic>> resendOTP({
    required String email,
  }) async {
    final url = '${ApiConfig.authUrl}/resend-otp';
    
    final body = {'email': email};
    
    try {
      final response = await HttpService.post(url, body);
      
      if (response['success'] == true) {
        return {
          'success': true,
          'message': response['message'],
          'expiresAt': response['data']['expiresAt'],
        };
      } else {
        throw ApiException(
          statusCode: 400,
          message: response['message'] ?? 'Failed to resend OTP',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
  
  /// Login user
  /// 
  /// Authenticates user and returns JWT token
  /// Saves token and user data to local storage
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = '${ApiConfig.authUrl}/login';
    
    final body = {
      'email': email,
      'password': password,
    };
    
    try {
      final response = await HttpService.post(url, body);
      
      if (response['success'] == true) {
        final token = response['data']['token'];
        final user = response['data']['user'];
        
        // Save token and user data
        await StorageHelper.saveToken(token);
        await StorageHelper.saveUser(user);
        
        return {
          'success': true,
          'message': response['message'],
          'token': token,
          'user': user,
        };
      } else {
        throw ApiException(
          statusCode: 401,
          message: response['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
  
  /// Forgot password - Step 1: Request OTP
  /// 
  /// Sends password reset OTP to user's email
  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    final url = '${ApiConfig.authUrl}/forgot-password';
    
    final body = {'email': email};
    
    try {
      final response = await HttpService.post(url, body);
      
      if (response['success'] == true) {
        // Save email for next step
        await StorageHelper.savePendingEmail(email);
        
        return {
          'success': true,
          'message': response['message'],
          'expiresAt': response['data']['expiresAt'],
        };
      } else {
        throw ApiException(
          statusCode: 400,
          message: response['message'] ?? 'Failed to send reset OTP',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
  
  /// Forgot password - Step 2: Verify reset OTP
  /// 
  /// Validates the OTP sent for password reset
  static Future<Map<String, dynamic>> verifyResetOTP({
    required String email,
    required String otpCode,
  }) async {
    final url = '${ApiConfig.authUrl}/verify-reset-otp';
    
    final body = {
      'email': email,
      'otpCode': otpCode,
    };
    
    try {
      final response = await HttpService.post(url, body);
      
      if (response['success'] == true) {
        return {
          'success': true,
          'message': response['message'],
        };
      } else {
        throw ApiException(
          statusCode: 400,
          message: response['message'] ?? 'Invalid OTP',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
  
  /// Forgot password - Step 3: Reset password
  /// 
  /// Sets new password for the user
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final url = '${ApiConfig.authUrl}/reset-password';
    
    final body = {
      'email': email,
      'newPassword': newPassword,
    };
    
    try {
      final response = await HttpService.post(url, body);
      
      if (response['success'] == true) {
        // Clear pending email
        await StorageHelper.clearPendingEmail();
        
        return {
          'success': true,
          'message': response['message'],
        };
      } else {
        throw ApiException(
          statusCode: 400,
          message: response['message'] ?? 'Failed to reset password',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
  
  /// Logout user
  /// 
  /// Clears all stored data
  static Future<void> logout() async {
    await StorageHelper.clearAll();
    ApiConfig.log('User logged out');
  }
  
  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    return await StorageHelper.isLoggedIn();
  }
  
  /// Get current user data
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    return await StorageHelper.getUser();
  }
}
```

---

## 📝 Step 5: Example Usage in Flutter Screens

### Registration Screen Example

```dart
import 'package:flutter/material.dart';
import '../core/services/auth_service.dart';
import '../core/services/http_service.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final result = await AuthService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      setState(() => _isLoading = false);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'OTP sent to your email!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate to OTP verification screen
      Navigator.pushNamed(
        context,
        '/verify-otp',
        arguments: {
          'email': result['email'],
          'type': 'registration',
        },
      );
      
    } on ApiException catch (e) {
      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### OTP Verification Screen Example

```dart
import 'package:flutter/material.dart';
import '../core/services/auth_service.dart';
import '../core/services/http_service.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final String type; // 'registration' or 'password_reset'
  
  OTPVerificationScreen({
    required this.email,
    required this.type,
  });
  
  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;
  
  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
  
  Future<void> _handleVerifyOTP() async {
    if (_otpController.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter 6-digit OTP code')),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final result = await AuthService.verifyOTP(
        email: widget.email,
        otpCode: _otpController.text.trim(),
      );
      
      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Verification successful!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate to login screen
      Navigator.pushReplacementNamed(context, '/login');
      
    } on ApiException catch (e) {
      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  Future<void> _handleResendOTP() async {
    setState(() => _isResending = true);
    
    try {
      final result = await AuthService.resendOTP(email: widget.email);
      
      setState(() => _isResending = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'New OTP sent to your email!'),
          backgroundColor: Colors.green,
        ),
      );
      
    } on ApiException catch (e) {
      setState(() => _isResending = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify OTP')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the 6-digit code sent to:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              widget.email,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 32),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'OTP Code',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, letterSpacing: 8),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleVerifyOTP,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Verify OTP'),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: _isResending ? null : _handleResendOTP,
              child: _isResending
                  ? Text('Resending...')
                  : Text('Resend OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Login Screen Example

```dart
import 'package:flutter/material.dart';
import '../core/services/auth_service.dart';
import '../core/services/http_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final result = await AuthService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      setState(() => _isLoading = false);
      
      // Navigate to home screen
      Navigator.pushReplacementNamed(context, '/home');
      
    } on ApiException catch (e) {
      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Login'),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot-password');
                },
                child: Text('Forgot Password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 🧪 Step 6: Testing the Integration

### Test Connection Widget

Add this to your app for quick testing:

```dart
import 'package:flutter/material.dart';
import '../core/config/api_config.dart';
import '../core/services/http_service.dart';

class ConnectionTestWidget extends StatefulWidget {
  @override
  _ConnectionTestWidgetState createState() => _ConnectionTestWidgetState();
}

class _ConnectionTestWidgetState extends State<ConnectionTestWidget> {
  String _status = 'Not tested';
  bool _isLoading = false;
  
  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing...';
    });
    
    try {
      // Test Auth Service
      final response = await HttpService.get('${ApiConfig.baseUrl}:3001/health');
      
      setState(() {
        _isLoading = false;
        _status = '✅ Backend Connected!\n${response['service']} is ${response['status']}';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = '❌ Connection Failed!\n$e';
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Backend Connection Test',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(_status, textAlign: TextAlign.center),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _testConnection,
              child: Text('Test Connection'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🔍 Step 7: Debugging Checklist

### Backend Checklist ✅

1. **All services running**:
   ```powershell
   cd C:\PTU\medtrack\backend
   .\start-all-services.ps1
   ```

2. **Check Auth Service logs** - should show:
   ```
   🔧 Environment Check:
     EMAIL_USER: ✓ Set
     EMAIL_PASSWORD: ✓ Set
   ```

3. **Test backend directly**:
   ```powershell
   Invoke-RestMethod http://localhost:3001/health
   ```

### Frontend Checklist ✅

1. **API Config correct**:
   - `_devBaseUrl = 'http://localhost'` ✅
   - NOT `'http://10.0.2.2'` (that's for Android Emulator)

2. **Dependencies installed**:
   ```bash
   flutter pub get
   ```

3. **Chrome DevTools open** (F12):
   - Console tab: See API logs
   - Network tab: See HTTP requests

### Common Issues & Solutions

#### Issue: "Failed to connect to server"

**Solution**: Backend not running
```powershell
cd C:\PTU\medtrack\backend
.\start-all-services.ps1
```

#### Issue: "CORS policy" error in Chrome

**Solution**: Already fixed in backend! Restart services:
```powershell
.\kill-all-services.ps1
.\start-all-services.ps1
```

#### Issue: "OTP email not received"

**Checklist**:
1. Check backend Auth Service logs - should show:
   ```
   📧 Attempting to send OTP email
   ✅ Email sent successfully
   ```
2. Check `.env` file has correct `EMAIL_PASSWORD`
3. Check spam folder
4. Test with: `.\test-otp-email.ps1`

#### Issue: "Invalid token" / 401 errors

**Solution**: Token expired or not saved
```dart
// Check if logged in
final isLoggedIn = await AuthService.isLoggedIn();
if (!isLoggedIn) {
  // Redirect to login
}
```

---

## 📊 Step 8: Complete Flow Diagram

```
┌─────────────────────────────────────────────────────────┐
│                   Registration Flow                     │
└─────────────────────────────────────────────────────────┘

Flutter Web                          Backend
     │                                   │
     │  POST /api/auth/register          │
     │  {name, email, password}          │
     ├──────────────────────────────────>│
     │                                   │ Create user
     │                                   │ Generate OTP
     │                                   │ Send email 📧
     │  201 {userId, email, expiresAt}   │
     │<──────────────────────────────────┤
     │                                   │
     │  Save email to pending            │
     │  Navigate to OTP screen           │
     │                                   │
     │  POST /api/auth/verify-otp        │
     │  {email, otpCode}                 │
     ├──────────────────────────────────>│
     │                                   │ Verify OTP
     │                                   │ Mark verified
     │  200 {success, userId}            │
     │<──────────────────────────────────┤
     │                                   │
     │  Navigate to login                │
     │                                   │
     │  POST /api/auth/login             │
     │  {email, password}                │
     ├──────────────────────────────────>│
     │                                   │ Verify password
     │                                   │ Generate JWT
     │  200 {token, user}                │
     │<──────────────────────────────────┤
     │                                   │
     │  Save token & user                │
     │  Navigate to home                 │
     │                                   │
```

---

## ✅ Final Verification Steps

### 1. Start Backend
```powershell
cd C:\PTU\medtrack\backend
.\start-all-services.ps1
```

### 2. Run Flutter Web
```bash
cd C:\PTU\medtrack
flutter run -d chrome
```

### 3. Test Complete Flow

1. **Register** a new user
2. **Check email** for OTP (including spam folder)
3. **Verify OTP** with the 6-digit code
4. **Login** with credentials
5. **Access protected routes** (Profile, Reports, etc.)

### 4. Monitor Logs

**Backend**: Check Auth Service window for:
```
📨 Incoming Request: POST /api/auth/register
🔐 Register endpoint hit
📧 Attempting to send OTP email
✅ Email sent successfully
```

**Frontend**: Check Chrome DevTools Console for:
```
🌐 [API] POST: http://localhost:3001/api/auth/register
🌐 [API] Response Status: 201
```

---

## 🎉 Success Indicators

You'll know integration is successful when:

- ✅ Backend shows incoming requests in logs
- ✅ OTP emails arrive within 30 seconds
- ✅ No CORS errors in Chrome DevTools
- ✅ JWT token saved after login
- ✅ Authenticated requests work (Profile, Reports, etc.)
- ✅ Error messages display clearly in UI
- ✅ No network errors in Network tab

---

## 📚 Quick Reference

### API Endpoints
- Register: `POST localhost:3001/api/auth/register`
- Verify OTP: `POST localhost:3001/api/auth/verify-otp`
- Login: `POST localhost:3001/api/auth/login`
- Forgot Password: `POST localhost:3001/api/auth/forgot-password`

### Key Files Created
- `lib/core/config/api_config.dart` - API configuration
- `lib/core/services/http_service.dart` - HTTP client
- `lib/core/services/auth_service.dart` - Auth operations
- `lib/core/utils/storage_helper.dart` - Local storage

### Testing Commands
```powershell
# Test backend
.\test-otp-email.ps1

# Restart backend
.\kill-all-services.ps1
.\start-all-services.ps1

# Run Flutter Web
flutter run -d chrome
```

---

**Your integration is now complete! 🚀**

The frontend and backend are fully connected with proper error handling, authentication flow, and OTP email delivery!
