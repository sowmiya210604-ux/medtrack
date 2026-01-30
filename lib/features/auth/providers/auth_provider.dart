import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/storage_helper.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = true;
  String? _errorMessage;

  // Login attempt tracking
  final Map<String, int> _loginAttempts = {};
  final Map<String, DateTime> _blockExpiry = {};
  static const int _maxAttempts = 5;
  String? _blockedPhone;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get blockedPhone => _blockedPhone;

  int getLoginAttempts(String phone) => _loginAttempts[phone] ?? 0;
  int getRemainingAttempts(String phone) =>
      _maxAttempts - getLoginAttempts(phone);
  bool isPhoneBlocked(String phone) {
    final expiry = _blockExpiry[phone];
    if (expiry != null && DateTime.now().isBefore(expiry)) {
      return true;
    }
    // Clear expired block
    if (expiry != null && DateTime.now().isAfter(expiry)) {
      _blockExpiry.remove(phone);
      _loginAttempts.remove(phone);
      _blockedPhone = null;
    }
    return false;
  }

  /// 🔹 Initialize auth state (APP START)
  Future<void> initialize() async {
    try {
      _isLoading = true;
      notifyListeners();

      final token = await StorageHelper.getToken();

      if (token != null && token.isNotEmpty) {
        final userData = await StorageHelper.getUser();
        if (userData != null) {
          _currentUser = User.fromJson(userData);
        }
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

      // Check if phone is blocked
      if (isPhoneBlocked(phone)) {
        _errorMessage = 'Too many failed attempts. Please reset your password.';
        _blockedPhone = phone;
        return false;
      }

      // Call backend API to login
      final userData = await AuthService.login(phone, password);

      // Clear attempts on successful login
      _loginAttempts.remove(phone);
      _blockExpiry.remove(phone);
      _blockedPhone = null;

      // Set user data and authentication state
      _currentUser = User.fromJson(userData);
      _isAuthenticated = true;

      return true;
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      _errorMessage = errorMsg;
      _isAuthenticated = false;

      // Track failed attempts for incorrect password errors
      if (errorMsg.toLowerCase().contains('invalid credentials') ||
          errorMsg.toLowerCase().contains('incorrect') ||
          errorMsg.toLowerCase().contains('password')) {
        _loginAttempts[phone] = (_loginAttempts[phone] ?? 0) + 1;

        if (_loginAttempts[phone]! >= _maxAttempts) {
          // Block the phone number for 30 minutes
          _blockExpiry[phone] = DateTime.now().add(const Duration(minutes: 30));
          _blockedPhone = phone;
          _errorMessage =
              'Account locked due to too many failed attempts. Please reset your password.';
        } else {
          final remaining = _maxAttempts - _loginAttempts[phone]!;
          _errorMessage = '$errorMsg. $remaining attempts remaining.';
        }
      }

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

      // Get pending email from storage
      final email = await StorageHelper.getPendingEmail();

      if (email == null) {
        _errorMessage = 'No pending verification found';
        return false;
      }

      // Call backend API to verify OTP (this saves token and user)
      await AuthService.verifyOtp(email, otp);

      // Load user data from storage
      final userData = await StorageHelper.getUser();

      if (userData != null) {
        _currentUser = User.fromJson(userData);
        _isAuthenticated = true;
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 VERIFY PASSWORD RESET OTP
  Future<bool> verifyPasswordResetOTP(String otp) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Get pending email from storage
      final email = await StorageHelper.getPendingEmail();

      if (email == null) {
        _errorMessage = 'No pending verification found';
        return false;
      }

      // Verify OTP for password reset (doesn't log in user)
      await AuthService.verifyPasswordResetOtp(email, otp);

      // Store OTP for use in reset password step
      await StorageHelper.savePendingOtp(otp);

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 RESEND OTP
  Future<bool> resendOTP({String? purpose}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Get pending email from storage
      final email = await StorageHelper.getPendingEmail();

      if (email == null || email.isEmpty) {
        _errorMessage = 'No pending verification found';
        return false;
      }

      // Call backend to resend OTP with optional purpose
      await AuthService.resendOtp(email, purpose: purpose);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
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

      // Call backend to send OTP for password reset
      await AuthService.forgotPassword(email);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
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

      // Get pending email and OTP from storage
      final email = await StorageHelper.getPendingEmail();
      final otp = await StorageHelper.getPendingOtp();

      if (email == null || email.isEmpty || otp == null || otp.isEmpty) {
        throw Exception('Missing email or OTP. Please restart the process.');
      }

      // Call backend to reset password
      await AuthService.resetPassword(email, otp, newPassword);

      // Clear login attempts and blocks for the associated phone number
      if (_blockedPhone != null) {
        _loginAttempts.remove(_blockedPhone);
        _blockExpiry.remove(_blockedPhone);
        _blockedPhone = null;
      }

      // Clear pending data
      await StorageHelper.savePendingEmail('');
      await StorageHelper.savePendingOtp('');

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 CLEAR LOGIN ATTEMPTS (for testing or admin)
  void clearLoginAttempts(String phone) {
    _loginAttempts.remove(phone);
    _blockExpiry.remove(phone);
    if (_blockedPhone == phone) {
      _blockedPhone = null;
    }
    notifyListeners();
  }

  /// 🔹 LOGOUT
  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      await AuthService.logout();

      _currentUser = null;
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 FETCH PROFILE FROM BACKEND
  Future<bool> fetchProfile() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final userData = await AuthService.getProfile();
      _currentUser = User.fromJson(userData);

      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');

      // If unauthorized, clear session
      if (_errorMessage?.contains('401') == true ||
          _errorMessage?.contains('403') == true ||
          _errorMessage?.contains('token') == true) {
        await logout();
      }

      return false;
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
