import 'package:flutter/material.dart';
import 'package:base42_events_mobile/consts/api.dart';
import 'package:base42_events_mobile/models/user.dart';
import 'package:base42_events_mobile/services/user_service.dart';
import 'package:base42_events_mobile/services/secure_storage_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
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
  final FlutterAppAuth _appAuth = const FlutterAppAuth();

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      _token = await _storageService.getToken(SecureStorageService.jwtTokenKey);
      final isExpired = await _storageService.isAuthTokenExpired();

      if (_token != null && isExpired) {
        developer.log('Token expired', name: 'AuthProvider');
        await logout();
        return;
      }

      if (_token != null && !isExpired) {
        _currentUser = await _userService.getCurrentAuthenticatedUser(_token!);
        developer.log(
          'User data loaded: ${_currentUser?.username}',
          name: 'AuthProvider',
        );
      }
    } catch (e) {
      developer.log('Auth check failed: $e', name: 'AuthProvider', error: e);
      await logout();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isUserCancelled(Object e) {
    if (e is FlutterAppAuthUserCancelledException) return true;
    if (e is PlatformException && e.code == 'user_canceled') return true;

    return false;
  }

  Future<void> login() async {
    try {
      final authResponse = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          keycloakClientId,
          keycloakRedirectUri,
          issuer: keycloakIssuerUrl,
          scopes: ['openid', 'profile', 'email'],
          promptValues: ['login'],
        ),
      );

      final accessToken = authResponse.accessToken;
      await exchangeForStrapiToken(accessToken);
    } catch (e) {
      if (isUserCancelled(e)) {
        return;
      }
      rethrow;
    }
  }

  Future<void> register() async {
    try {
      final authResponse = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          keycloakClientId,
          keycloakRedirectUri,
          serviceConfiguration: AuthorizationServiceConfiguration(
            authorizationEndpoint: keycloakRegisterUrl,
            tokenEndpoint: keycloakTokenEndpoint,
          ),
          scopes: ['openid', 'profile', 'email'],
          promptValues: ['select_account'],
        ),
      );

      final accessToken = authResponse.accessToken;
      await exchangeForStrapiToken(accessToken);
    } catch (e) {
      if (isUserCancelled(e)) {
        return;
      }
      developer.log(
        'Keycloak registration failed: $e',
        name: 'AuthProvider',
        error: e,
      );
      rethrow;
    }
  }

  Future<void> exchangeForStrapiToken(String? keycloakToken) async {
    try {
      if (keycloakToken == null) {
        throw Exception('No access token returned from Keycloak');
      }

      final result = await _userService.loginWithKeycloak(keycloakToken);
      _currentUser = result.user;
      _token = result.jwt;

      if (_token == null) {
        throw Exception('Failed to retrieve Strapi auth token');
      }

      await _storageService.saveToken(
        SecureStorageService.jwtTokenKey,
        _token!,
      );

      final expiresIn = result.expiresIn ?? 900;
      final expiration = DateTime.now().add(Duration(seconds: expiresIn));

      await _storageService.saveToken(
        SecureStorageService.jwtExpirationKey,
        expiration.millisecondsSinceEpoch.toString(),
      );
      notifyListeners();
    } catch (e) {
      if (isUserCancelled(e)) {
        return;
      }
      developer.log(
        'Strapi token exchange failed: $e',
        name: 'AuthProvider',
        error: e,
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _userService.logout(_token!);
    } catch (e) {
      if (isUserCancelled(e)) {
        return;
      }
      developer.log(
        'Logout API call failed (non-critical): $e',
        name: 'AuthProvider',
        error: e,
      );
    } finally {
      await _storageService.deleteToken(SecureStorageService.jwtTokenKey);
      await _storageService.deleteToken(SecureStorageService.jwtExpirationKey);
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

    return _token ??
        await _storageService.getToken(SecureStorageService.jwtTokenKey);
  }
}
