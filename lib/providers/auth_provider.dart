import 'package:flutter/material.dart';
import 'package:base42_events_mobile/models/user.dart';
import 'package:base42_events_mobile/services/user_service.dart';
import 'package:base42_events_mobile/services/secure_storage_service.dart';
import 'dart:developer' as developer;

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  String? _token;
  bool _isLoading = true;

  User? get currentUser => _currentUser;
  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;

  final UserService _userService = UserService();
  final SecureStorageService _storageService = SecureStorageService();

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      _token = await _storageService.getToken();
      final isExpired = await _storageService.isAuthTokenExpired();

      if (_token != null && isExpired) {
        developer.log('Token expired', name: 'AuthProvider');
        await logout();
      } else if (_token != null && !isExpired) {
        developer.log('Valid token found in storage', name: 'AuthProvider');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      developer.log(
        'Auth status check failed: $e',
        name: 'AuthProvider',
        error: e,
      );
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      developer.log('Login attempt for: $email', name: 'AuthProvider');

      final result = await _userService.loginUser(email, password);
      _currentUser = result.user;
      _token = result.jwt;

      if (_token == null) {
        throw Exception('Failed to retrieve auth token');
      }

      await _storageService.saveToken('jwt', _token!);

      final expiresIn = result.expiresIn ?? 900; // 15 minutes default
      final expiration = DateTime.now().add(Duration(seconds: expiresIn));
      await _storageService.saveToken(
        'jwt_token_expiration',
        expiration.millisecondsSinceEpoch.toString(),
      );

      developer.log(
        'Login successful for user: ${_currentUser?.username}',
        name: 'AuthProvider',
      );
      notifyListeners();
    } catch (e) {
      developer.log('Login failed: $e', name: 'AuthProvider', error: e);
      rethrow;
    }
  }

  Future<void> signup(String email, String username, String password) async {
    try {
      developer.log('Signup attempt for: $email', name: 'AuthProvider');

      final result = await _userService.addUser(email, username, password);

      _currentUser = result.user;
      _token = result.jwt;

      if (_token == null) {
        throw Exception('Failed to retrieve auth token');
      }

      await _storageService.saveToken('jwt', _token!);

      final expiresIn = result.expiresIn ?? 900; // 15 minutes default
      final expiration = DateTime.now().add(Duration(seconds: expiresIn));
      await _storageService.saveToken(
        'jwt_token_expiration',
        expiration.millisecondsSinceEpoch.toString(),
      );

      developer.log(
        'Signup successful for user: ${_currentUser?.username}',
        name: 'AuthProvider',
      );
      notifyListeners();
    } catch (e) {
      developer.log('Signup failed: $e', name: 'AuthProvider', error: e);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      if (_token != null) {
        await _userService.logout(_token!);
      }
    } catch (e) {
      developer.log(
        'Logout API call failed (non-critical): $e',
        name: 'AuthProvider',
        error: e,
      );
    } finally {
      await _storageService.deleteToken('jwt');
      await _storageService.deleteToken('jwt_token_expiration');
      _currentUser = null;
      _token = null;

      developer.log(
        'Logout successful - local session cleared',
        name: 'AuthProvider',
      );
      notifyListeners();
    }
  }

  Future<String?> getAuthToken() async {
    final isExpired = await _storageService.isAuthTokenExpired();

    if (isExpired) {
      developer.log('Token expired', name: 'AuthProvider');
      return null;
    }

    return _token ?? await _storageService.getToken('jwt');
  }
}
