import '../config/api_config.dart';
import '../utils/storage_helper.dart';
import 'http_service.dart';

class AuthService {
  static Future<void> register(
      String name, String email, String phone, String password) async {
    await HttpService.post('${ApiConfig.authUrl}/register', {
      'name': name,
      'email': email,
      'password': password,
      'phoneNumber': phone, // Changed from 'phone' to 'phoneNumber'
    });
    await StorageHelper.savePendingEmail(email);
  }

  static Future<void> verifyOtp(String email, String otp) async {
    final res = await HttpService.post('${ApiConfig.authUrl}/verify-otp', {
      'email': email,
      'otpCode': otp,
    });
    // Save token and user data after successful verification
    await StorageHelper.saveToken(res['token']);
    await StorageHelper.saveUser(res['user']);
  }

  static Future<Map<String, dynamic>> login(
      String phoneNumber, String password) async {
    final res = await HttpService.post('${ApiConfig.authUrl}/login', {
      'phoneNumber': phoneNumber,
      'password': password,
    });

    // Login returns { message, data: { token, user } }
    final token = res['data']['token'];
    final user = res['data']['user'];

    await StorageHelper.saveToken(token);
    await StorageHelper.saveUser(user);

    return user;
  }

  static Future<Map<String, dynamic>> getProfile() async {
    final res = await HttpService.get(
      '${ApiConfig.authUrl}/me',
      requiresAuth: true,
    );
    // Profile returns { user: {...} }
    final user = res['user'];
    await StorageHelper.saveUser(user);
    return user;
  }

  static Future<void> forgotPassword(String email) async {
    await HttpService.post('${ApiConfig.authUrl}/forgot-password', {
      'email': email,
    });
    // Save email for later use in OTP verification
    await StorageHelper.savePendingEmail(email);
  }

  static Future<void> verifyPasswordResetOtp(String email, String otp) async {
    final res = await HttpService.post('${ApiConfig.authUrl}/verify-otp', {
      'email': email,
      'otpCode': otp,
      'purpose': 'password_reset',
    });
    // For password reset, we don't save token yet, just validate OTP
    // Keep email stored for reset password step
  }

  static Future<void> resetPassword(
    String email,
    String otp,
    String newPassword,
  ) async {
    await HttpService.post('${ApiConfig.authUrl}/reset-password', {
      'email': email,
      'otpCode': otp,
      'newPassword': newPassword,
    });
    // Clear pending email after successful reset
    await StorageHelper.savePendingEmail('');
  }

  static Future<void> resendOtp(String email, {String? purpose}) async {
    final Map<String, dynamic> body = {
      'email': email,
    };

    if (purpose != null) {
      body['purpose'] = purpose;
    }

    await HttpService.post('${ApiConfig.authUrl}/resend-otp', body);
  }

  static Future<void> logout() async {
    await StorageHelper.clearAll();
  }
}
