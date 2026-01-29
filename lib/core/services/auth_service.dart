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
      'phoneNumber': phone,  // Changed from 'phone' to 'phoneNumber'
    });
    await StorageHelper.savePendingEmail(email);
  }

  static Future<void> verifyOtp(String email, String otp) async {
    await HttpService.post('${ApiConfig.authUrl}/verify-otp', {
      'email': email,
      'otpCode': otp,
    });
  }

  static Future<void> login(String email, String password) async {
    final res = await HttpService.post('${ApiConfig.authUrl}/login', {
      'phoneNumber': email,  // Backend expects phoneNumber for login
      'password': password,
    });
    await StorageHelper.saveToken(res['data']['token']);
    await StorageHelper.saveUser(res['data']['user']);
  }

  static Future<void> logout() async {
    await StorageHelper.clearAll();
  }
}
