import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsProvider extends ChangeNotifier {
  static const _storage = FlutterSecureStorage();

  static const _keyNotifications = 'settings_notifications';
  static const _keyThemeMode = 'settings_theme_mode';
  static const _keyLocale = 'settings_locale';

  bool _notificationsEnabled = true;
  ThemeMode _themeMode = ThemeMode.dark;
  String _locale = 'mk';

  bool get notificationsEnabled => _notificationsEnabled;
  ThemeMode get themeMode => _themeMode;
  String get locale => _locale;

  SettingsProvider() {
    _load();
  }

  Future<void> _load() async {
    final notif = await _storage.read(key: _keyNotifications);
    final theme = await _storage.read(key: _keyThemeMode);
    final locale = await _storage.read(key: _keyLocale);

    _notificationsEnabled = notif != 'false';
    _themeMode = switch (theme) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.dark,
    };
    _locale = locale ?? 'mk';
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    await _storage.write(key: _keyNotifications, value: value.toString());
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

  Future<void> setLocale(String locale) async {
    _locale = locale;
    await _storage.write(key: _keyLocale, value: locale);
    notifyListeners();
  }
}
