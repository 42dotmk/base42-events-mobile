import 'package:base42_events_mobile/services/fcm_service.dart';
import 'package:flutter/material.dart';
import 'package:base42_events_mobile/services/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsProvider extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();

  static const _keyNotifications =
      SecureStorageService.notificationsEnabledKey;
  static const _keyThemeMode = 'settings_theme_mode';

  bool _notificationsEnabled = true;
  ThemeMode _themeMode = ThemeMode.dark;

  bool get notificationsEnabled => _notificationsEnabled;
  ThemeMode get themeMode => _themeMode;

  SettingsProvider() {
    _load();
  }

  Future<void> _load() async {
    final notif = await _storage.read(key: _keyNotifications);
    final theme = await _storage.read(key: _keyThemeMode);

    _notificationsEnabled = notif != 'false';
    _themeMode = switch (theme) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    FCMService.instance.setNotificationsEnabled(
      _notificationsEnabled,
      syncToDevice: false,
    );
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    await _storage.write(
      key: _keyNotifications,
      value: value.toString(),
    );
    await FCMService.instance.setNotificationsEnabled(value);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _storage.write(key: _keyThemeMode, value: value);
    notifyListeners();
  }
}
