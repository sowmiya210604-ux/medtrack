import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = true;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// 🔹 Initialize auth state (APP START)
  Future<void> initialize() async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null && token.isNotEmpty) {
        _currentUser = User(
          id: prefs.getString('user_id') ?? '1',
          name: prefs.getString('user_name') ?? 'User',
          email: prefs.getString('user_email') ?? '',
          phone: prefs.getString('user_phone') ?? '',
          profileImage: prefs.getString('user_profile_image'),
          dateOfBirth: prefs.getString('user_dob') != null
    ? DateTime.tryParse(prefs.getString('user_dob')!)
    : null,

          gender: prefs.getString('user_gender'),
          bloodGroup: prefs.getString('user_blood_group'),
          address: prefs.getString('user_address'),
        );
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
      }
    } catch (e) {
      _errorMessage = 'Failed to initialize authentication';
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 LOGIN
  Future<bool> login(String phone, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // TODO: Replace with backend API call
      await Future.delayed(const Duration(seconds: 2));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'auth_token',
        'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      );
      await prefs.setString('user_phone', phone);

      _currentUser = User(
        id: '1',
        name: prefs.getString('user_name') ?? 'User',
        email: prefs.getString('user_email') ?? '',
        phone: phone,
        profileImage: prefs.getString('user_profile_image'),
      );

      _isAuthenticated = true;
      return true;
    } catch (e) {
      _errorMessage = 'Login failed';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 REGISTER
  Future<bool> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Call backend API to register user with phone number
      await AuthService.register(name, email, phone, password);

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 OTP VERIFY
  Future<bool> verifyOTP(String otp) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // TODO: Backend API
      await Future.delayed(const Duration(seconds: 1));

      return true;
    } catch (e) {
      _errorMessage = 'OTP verification failed';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 RESEND OTP
  Future<bool> resendOTP() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      _errorMessage = 'Failed to resend OTP';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 FORGOT PASSWORD
  Future<bool> forgotPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      _errorMessage = 'Failed to send reset link';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 RESET PASSWORD
  Future<bool> resetPassword(
    String newPassword,
    String confirmPassword,
  ) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (newPassword != confirmPassword) {
        throw Exception('Passwords do not match');
      }

      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 LOGOUT
  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _currentUser = null;
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 UPDATE PROFILE
  Future<bool> updateProfile(User updatedUser) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', updatedUser.name);
      await prefs.setString('user_email', updatedUser.email);

      _currentUser = updatedUser;
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 UPDATE PROFILE IMAGE
  Future<bool> updateProfileImage(String imagePath) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_profile_image', imagePath);

      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(profileImage: imagePath);
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile image';
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
