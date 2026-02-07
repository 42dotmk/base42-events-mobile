import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  Future<void> saveToken(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> getToken(String key) async {
    if (key == 'jwt_token_expiration') {
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
    final expirationStr = await _storage.read(key: 'jwt_token_expiration');
    if (expirationStr != null) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(expirationStr));
    }
    return null;
  }

  Future<bool> isAuthTokenExpired() async {
    final expiration = await getAuthTokenExpiration();
    if (expiration == null) return true;
    return DateTime.now().isAfter(expiration);
  }
}
