import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/local/local_storage_service.dart';

part 'settings_provider.g.dart';

/// App settings model
class AppSettings {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final bool soundEnabled;
  final String language;
  final bool autoPlayVideos;
  final double textSize; // 0.8 to 1.2

  const AppSettings({
    this.isDarkMode = false,
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.language = 'en',
    this.autoPlayVideos = true,
    this.textSize = 1.0,
  });

  AppSettings copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    bool? soundEnabled,
    String? language,
    bool? autoPlayVideos,
    double? textSize,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      language: language ?? this.language,
      autoPlayVideos: autoPlayVideos ?? this.autoPlayVideos,
      textSize: textSize ?? this.textSize,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'notificationsEnabled': notificationsEnabled,
      'soundEnabled': soundEnabled,
      'language': language,
      'autoPlayVideos': autoPlayVideos,
      'textSize': textSize,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      language: json['language'] as String? ?? 'en',
      autoPlayVideos: json['autoPlayVideos'] as bool? ?? true,
      textSize: (json['textSize'] as num?)?.toDouble() ?? 1.0,
    );
  }
}

/// Provider for app settings
@riverpod
class Settings extends _$Settings {
  static const String _settingsKey = 'app_settings';

  @override
  Future<AppSettings> build() async {
    final localStorage = LocalStorageService();
    final settingsJson = await localStorage.getString(_settingsKey);

    if (settingsJson != null) {
      try {
        final map = Map<String, dynamic>.from(
          settingsJson as Map,
        );
        return AppSettings.fromJson(map);
      } catch (e) {
        // If parsing fails, return default settings
        return const AppSettings();
      }
    }

    return const AppSettings();
  }

  /// Toggle dark mode
  Future<void> toggleDarkMode() async {
    final current = await future;
    final updated = current.copyWith(isDarkMode: !current.isDarkMode);
    await _saveSettings(updated);
  }

  /// Set dark mode
  Future<void> setDarkMode(bool enabled) async {
    final current = await future;
    final updated = current.copyWith(isDarkMode: enabled);
    await _saveSettings(updated);
  }

  /// Toggle notifications
  Future<void> toggleNotifications() async {
    final current = await future;
    final updated = current.copyWith(
      notificationsEnabled: !current.notificationsEnabled,
    );
    await _saveSettings(updated);
  }

  /// Toggle sound
  Future<void> toggleSound() async {
    final current = await future;
    final updated = current.copyWith(soundEnabled: !current.soundEnabled);
    await _saveSettings(updated);
  }

  /// Toggle auto-play videos
  Future<void> toggleAutoPlayVideos() async {
    final current = await future;
    final updated = current.copyWith(autoPlayVideos: !current.autoPlayVideos);
    await _saveSettings(updated);
  }

  /// Set language
  Future<void> setLanguage(String languageCode) async {
    final current = await future;
    final updated = current.copyWith(language: languageCode);
    await _saveSettings(updated);
  }

  /// Set text size
  Future<void> setTextSize(double size) async {
    final current = await future;
    final updated = current.copyWith(textSize: size);
    await _saveSettings(updated);
  }

  /// Save settings to local storage
  Future<void> _saveSettings(AppSettings settings) async {
    state = AsyncValue.data(settings);
    final localStorage = LocalStorageService();
    await localStorage.setString(_settingsKey, settings.toJson());
  }
}

/// Provider for theme mode
@riverpod
ThemeMode themeMode(ThemeModeRef ref) {
  final settingsAsync = ref.watch(settingsProvider);

  return settingsAsync.when(
    data: (settings) => settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
    loading: () => ThemeMode.light,
    error: (_, __) => ThemeMode.light,
  );
}
