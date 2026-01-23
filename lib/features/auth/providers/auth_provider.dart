import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Initialize auth state from stored data
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        // TODO: Validate token with backend API
        // For now, we'll simulate it with stored user data
        final userJson = prefs.getString('user_data');
        if (userJson != null) {
          // In real app, parse the JSON
          _isAuthenticated = true;
          _currentUser = User(
            id: '1',
            name: prefs.getString('user_name') ?? 'User',
            email: prefs.getString('user_email') ?? '',
            phone: prefs.getString('user_phone') ?? '',
            profileImage: prefs.getString('user_profile_image'),
          );
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to initialize auth: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String phone, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Call backend API
      // Simulating API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful login - retrieve stored name from registration
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'auth_token', 'mock_token_${DateTime.now().millisecondsSinceEpoch}');
      await prefs.setString('user_phone', phone);

      // Get stored name from registration, default if not found
      final storedName = prefs.getString('user_name') ?? 'User';
      final storedEmail = prefs.getString('user_email') ?? '';
      final storedProfileImage = prefs.getString('user_profile_image');

      _currentUser = User(
        id: '1',
        name: storedName,
        email: storedEmail,
        phone: phone,
        profileImage: storedProfileImage,
      );
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register(
      String name, String email, String phone, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Call backend API
      await Future.delayed(const Duration(seconds: 2));

      // Store user details for login
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
      await prefs.setString('user_email', email);
      await prefs.setString('user_phone', phone);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Registration failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Verify OTP
  Future<bool> verifyOTP(String otp) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Call backend API
      await Future.delayed(const Duration(seconds: 1));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'OTP verification failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Resend OTP
  Future<bool> resendOTP() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Call backend API
      await Future.delayed(const Duration(seconds: 1));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to resend OTP: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Forgot Password
  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Call backend API
      await Future.delayed(const Duration(seconds: 1));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to send reset link: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Reset Password
  Future<bool> resetPassword(String newPassword, String confirmPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (newPassword != confirmPassword) {
        throw Exception('Passwords do not match');
      }

      // TODO: Call backend API
      await Future.delayed(const Duration(seconds: 1));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to reset password: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _currentUser = null;
      _isAuthenticated = false;
    } catch (e) {
      _errorMessage = 'Logout failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<bool> updateProfile(User updatedUser) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Call backend API
      await Future.delayed(const Duration(seconds: 1));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', updatedUser.name);
      await prefs.setString('user_email', updatedUser.email);

      _currentUser = updatedUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update profile image
  Future<bool> updateProfileImage(String imagePath) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_profile_image', imagePath);

      if (_currentUser != null) {
        _currentUser = User(
          id: _currentUser!.id,
          name: _currentUser!.name,
          email: _currentUser!.email,
          phone: _currentUser!.phone,
          profileImage: imagePath,
          dateOfBirth: _currentUser!.dateOfBirth,
          gender: _currentUser!.gender,
          bloodGroup: _currentUser!.bloodGroup,
          address: _currentUser!.address,
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile image: $e';
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
