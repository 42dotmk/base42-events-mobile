import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String jwtTokenKey = 'jwt';
  static const String jwtExpirationKey = 'jwt_token_expiration';
  static const String onboardingCompleteKey = 'onboarding_complete';

  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  Future<void> saveToken(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getToken(String key) async {
    if (key == jwtExpirationKey) {
      final expiration = await getAuthTokenExpiration();
      return expiration?.millisecondsSinceEpoch.toString();
    }
    return await _storage.read(key: key);
  }

  Future<void> deleteToken(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clearStorage() async {
    await _storage.deleteAll();
  }

  Future<DateTime?> getAuthTokenExpiration() async {
    final expirationString = await _storage.read(key: jwtExpirationKey);
    if (expirationString != null) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(expirationString));
    }
    return null;
  }

  Future<bool> isOnboardingComplete() async {
    final value = await _storage.read(key: onboardingCompleteKey);
    return value == 'true';
  }

  Future<void> markOnboardingComplete() async {
    await _storage.write(key: onboardingCompleteKey, value: 'true');
  }

  Future<bool> isAuthTokenExpired() async {
    final expiration = await getAuthTokenExpiration();
    if (expiration == null) return true;
    return DateTime.now().isAfter(expiration);
  }
}
