import 'package:flutter/material.dart';
import 'package:base42_events_mobile/consts/api.dart';
import 'package:base42_events_mobile/models/user.dart';
import 'package:base42_events_mobile/providers/attendance_provider.dart';
import 'package:base42_events_mobile/services/user_service.dart';
import 'package:base42_events_mobile/services/secure_storage_service.dart';
import 'package:base42_events_mobile/services/fcm_service.dart';
import 'package:base42_events_mobile/nav.dart';
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
  final AttendanceProvider? _attendanceProvider;

  AuthProvider({AttendanceProvider? attendanceProvider})
    : _attendanceProvider = attendanceProvider {
    _checkAuthStatus();
  }

  Future<void> loadUserEvents() async {
    if (_token == null || _currentUser == null) {
      debugPrint('Cannot load user events: no auth token or user data');
      return;
    }

    try {
      await _attendanceProvider?.loadUserEvents(_token!, _currentUser!.id);
      developer.log('User events loaded successfully', name: 'AuthProvider');
    } catch (e) {
      debugPrint('Failed to load user events: $e');
    }
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

        await loadUserEvents();
      }
    } catch (e) {
      debugPrint('Auth check failed: $e');
      await logout();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool hasUserCancelled(Object e) {
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
      if (hasUserCancelled(e)) {
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

      if (accessToken == null) {
        debugPrint(
          'accessToken is null after authorizeAndExchangeCode — aborting',
        );
        return;
      }

      await exchangeForStrapiToken(accessToken);
    } catch (e) {
      if (hasUserCancelled(e)) {
        return;
      }

      debugPrint('Keycloak registration failed: $e');
      rethrow;
    }
  }

  Future<void> exchangeForStrapiToken(String? keycloakToken) async {
    try {
      if (keycloakToken == null) {
        throw Exception('No access token returned from Keycloak');
      }

      final result = await _userService.loginWithKeycloak(keycloakToken);
      _token = result.jwt;

      if (_token == null) {
        throw Exception('Failed to retrieve Strapi auth token');
      }

      _currentUser = await _userService.getCurrentAuthenticatedUser(_token!);

      await _storageService.saveToken(
        SecureStorageService.jwtTokenKey,
        _token!,
      );

      final expiresIn = result.expiresIn ?? 900;

      await loadUserEvents();

      final expiration = DateTime.now().add(Duration(seconds: expiresIn));

      await _storageService.saveToken(
        SecureStorageService.jwtExpirationKey,
        expiration.millisecondsSinceEpoch.toString(),
      );

      await FCMService.instance.updateTokenOnBackend();

      notifyListeners();

      await _handlePendingEventNavigation();
    } catch (e) {
      if (hasUserCancelled(e)) {
        return;
      }
      await _storageService.deleteToken(SecureStorageService.jwtTokenKey);
      await _storageService.deleteToken(SecureStorageService.jwtExpirationKey);
      _currentUser = null;
      _token = null;
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
      if (hasUserCancelled(e)) {
        return;
      }
    } finally {
      await _storageService.deleteToken(SecureStorageService.jwtTokenKey);
      await _storageService.deleteToken(SecureStorageService.jwtExpirationKey);
      _currentUser = null;
      _token = null;

      _attendanceProvider?.clearAll();
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

  Future<void> refreshCurrentUser() async {
    if (_token == null) {
      throw Exception('Not authenticated');
    }

    try {
      _currentUser = await _userService.getCurrentAuthenticatedUser(_token!);
      notifyListeners();
      developer.log(
        'User data refreshed: ${_currentUser?.username}',
        name: 'AuthProvider',
      );
    } catch (e) {
      developer.log(
        'Failed to refresh user data: $e',
        name: 'AuthProvider',
        error: e,
      );
      rethrow;
    }
  }

  Future<void> _handlePendingEventNavigation() async {
    try {
      final pendingEventId = await _storageService.getPendingEventId();
      if (pendingEventId != null && pendingEventId.isNotEmpty) {
        await _storageService.clearPendingEventId();

        Future.delayed(const Duration(milliseconds: 500), () {
          AppRouterHelper.goToEventDetails(pendingEventId);
        });
      }
    } catch (e) {
      debugPrint("Error handling pending event navigation: $e");
    }
  }
}
