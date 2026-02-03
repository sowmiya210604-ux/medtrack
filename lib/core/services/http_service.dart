import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../utils/storage_helper.dart';

class HttpService {
  /// GET request
  static Future<Map<String, dynamic>> get(
    String url, {
    bool requiresAuth = false,
  }) async {
    try {
      ApiConfig.log('GET: $url');
      final headers = await _headers(requiresAuth);

      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(ApiConfig.receiveTimeout);

      return _handle(response);
    } on SocketException catch (e) {
      ApiConfig.log('ERROR: Network error - $e');
      throw ApiException(0, 'Cannot connect to backend. Is it running?');
    } on http.ClientException catch (e) {
      ApiConfig.log('ERROR: Client error - $e');
      throw ApiException(0, 'Failed to connect to server at $url');
    } catch (e) {
      ApiConfig.log('ERROR: $e');
      throw ApiException(0, e.toString());
    }
  }

  /// POST request
  static Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
  }) async {
    try {
      ApiConfig.log('POST: $url');
      ApiConfig.log('Body: ${_sanitize(body)}');

      final headers = await _headers(requiresAuth);

      final response = await http
          .post(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(ApiConfig.receiveTimeout);

      return _handle(response);
    } on SocketException catch (e) {
      ApiConfig.log('ERROR: Network error - $e');
      throw ApiException(0, 'Cannot connect to backend. Is it running?');
    } on http.ClientException catch (e) {
      ApiConfig.log('ERROR: Client error - $e');
      throw ApiException(0, 'Failed to connect to server at $url');
    } catch (e) {
      ApiConfig.log('ERROR: $e');
      throw ApiException(0, e.toString());
    }
  }

  /// PUT request
  static Future<Map<String, dynamic>> put(
    String url,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
  }) async {
    try {
      ApiConfig.log('PUT: $url');
      final headers = await _headers(requiresAuth);

      final response = await http
          .put(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(ApiConfig.receiveTimeout);

      return _handle(response);
    } catch (e) {
      ApiConfig.log('ERROR: $e');
      throw ApiException(0, e.toString());
    }
  }

  /// DELETE request
  static Future<Map<String, dynamic>> delete(
    String url, {
    bool requiresAuth = false,
  }) async {
    try {
      ApiConfig.log('DELETE: $url');
      final headers = await _headers(requiresAuth);

      final response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(ApiConfig.receiveTimeout);

      return _handle(response);
    } catch (e) {
      ApiConfig.log('ERROR: $e');
      throw ApiException(0, e.toString());
    }
  }

  static Future<Map<String, String>> _headers(bool auth) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (auth) {
      final token = await StorageHelper.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
        ApiConfig.log('Auth token attached: ${token.substring(0, 20)}...');
      } else {
        ApiConfig.log('⚠️ WARNING: No auth token found in storage!');
      }
    }
    return headers;
  }

  static Map<String, dynamic> _handle(http.Response response) {
    ApiConfig.log('Response: ${response.statusCode}');

    if (response.body.isEmpty) {
      throw ApiException(response.statusCode, 'Empty response from server');
    }

    try {
      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        ApiConfig.log('Success: ${data['message'] ?? 'OK'}');
        return data;
      }

      // Handle unauthorized/forbidden responses
      if (response.statusCode == 401 || response.statusCode == 403) {
        // Clear storage and force re-login
        StorageHelper.clearAll();
        throw ApiException(
          response.statusCode,
          data['error'] ?? 'Unauthorized. Please login again.',
        );
      }

      throw ApiException(
        response.statusCode,
        data['error'] ??
            data['message'] ??
            'Request failed with status ${response.statusCode}',
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(response.statusCode, 'Invalid response format');
    }
  }

  /// Sanitize body for logging (hide passwords)
  static String _sanitize(Map<String, dynamic> body) {
    final sanitized = Map<String, dynamic>.from(body);
    if (sanitized.containsKey('password')) sanitized['password'] = '***';
    if (sanitized.containsKey('newPassword')) sanitized['newPassword'] = '***';
    return jsonEncode(sanitized);
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);

  @override
  String toString() => message;
}
