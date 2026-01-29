class ApiConfig {
  static const bool isProduction = false;

  // Monolithic backend on single port
  static const String _devBaseUrl = 'http://localhost:5000/api';
  static const String _prodBaseUrl = 'https://api.medtrack.com/api';

  static String get baseUrl =>
      isProduction ? _prodBaseUrl : _devBaseUrl;

  // All endpoints use the same base URL (monolithic architecture)
  static String get authUrl => '$baseUrl/auth';
  static String get profileUrl => '$baseUrl/auth'; // Profile is part of auth
  static String get reportUrl => '$baseUrl/reports';
  static String get healthAnalysisUrl => '$baseUrl/health';
  static String get historyUrl => '$baseUrl/history';
  static String get notificationUrl => '$baseUrl/notifications';

  static const Duration receiveTimeout = Duration(seconds: 30);
  static const bool enableLogging = true;

  static void log(String message) {
    if (enableLogging) {
      print('🌐 [API] $message');
    }
  }
}
