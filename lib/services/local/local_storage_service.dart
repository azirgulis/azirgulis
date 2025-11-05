import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

/// Local storage service using Hive and SharedPreferences
class LocalStorageService {
  static SharedPreferences? _prefs;

  // Hive boxes
  Box? _userBox;
  Box? _progressBox;
  Box? _lessonsBox;
  Box? _settingsBox;

  /// Initialize local storage
  Future<void> init() async {
    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();

    // Initialize Hive boxes
    _userBox = await Hive.openBox(AppConstants.boxNameUser);
    _progressBox = await Hive.openBox(AppConstants.boxNameProgress);
    _lessonsBox = await Hive.openBox(AppConstants.boxNameLessons);
    _settingsBox = await Hive.openBox(AppConstants.boxNameSettings);
  }

  // ==================== SHARED PREFERENCES ====================

  /// Save onboarding complete status
  Future<void> setOnboardingComplete(bool value) async {
    await _prefs?.setBool(AppConstants.keyOnboardingComplete, value);
  }

  /// Check if onboarding is complete
  bool isOnboardingComplete() {
    return _prefs?.getBool(AppConstants.keyOnboardingComplete) ?? false;
  }

  /// Save selected language
  Future<void> setLanguage(String languageCode) async {
    await _prefs?.setString(AppConstants.keySelectedLanguage, languageCode);
  }

  /// Get selected language
  String getLanguage() {
    return _prefs?.getString(AppConstants.keySelectedLanguage) ?? 'en';
  }

  /// Save theme mode
  Future<void> setThemeMode(String mode) async {
    await _prefs?.setString(AppConstants.keyThemeMode, mode);
  }

  /// Get theme mode
  String getThemeMode() {
    return _prefs?.getString(AppConstants.keyThemeMode) ?? 'system';
  }

  /// Save notifications enabled
  Future<void> setNotificationsEnabled(bool value) async {
    await _prefs?.setBool(AppConstants.keyNotificationsEnabled, value);
  }

  /// Check if notifications are enabled
  bool areNotificationsEnabled() {
    return _prefs?.getBool(AppConstants.keyNotificationsEnabled) ?? true;
  }

  // ==================== HIVE OPERATIONS ====================

  /// Save user data locally
  Future<void> saveUserData(String userId, Map<String, dynamic> data) async {
    await _userBox?.put(userId, data);
  }

  /// Get user data locally
  Map<String, dynamic>? getUserData(String userId) {
    return _userBox?.get(userId) as Map<String, dynamic>?;
  }

  /// Delete user data locally
  Future<void> deleteUserData(String userId) async {
    await _userBox?.delete(userId);
  }

  /// Save progress data locally
  Future<void> saveProgressData(
    String userId,
    Map<String, dynamic> data,
  ) async {
    await _progressBox?.put(userId, data);
  }

  /// Get progress data locally
  Map<String, dynamic>? getProgressData(String userId) {
    return _progressBox?.get(userId) as Map<String, dynamic>?;
  }

  /// Save lesson data locally
  Future<void> saveLessonData(
    String lessonId,
    Map<String, dynamic> data,
  ) async {
    await _lessonsBox?.put(lessonId, data);
  }

  /// Get lesson data locally
  Map<String, dynamic>? getLessonData(String lessonId) {
    return _lessonsBox?.get(lessonId) as Map<String, dynamic>?;
  }

  /// Get all cached lessons
  Map<dynamic, dynamic>? getAllLessons() {
    return _lessonsBox?.toMap();
  }

  /// Save app settings
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await _settingsBox?.put('app_settings', settings);
  }

  /// Get app settings
  Map<String, dynamic>? getSettings() {
    return _settingsBox?.get('app_settings') as Map<String, dynamic>?;
  }

  /// Clear all local data (for logout)
  Future<void> clearAllData() async {
    await _userBox?.clear();
    await _progressBox?.clear();
    await _lessonsBox?.clear();
    // Don't clear settings box as it contains user preferences
  }

  /// Clear only user-specific data
  Future<void> clearUserData(String userId) async {
    await _userBox?.delete(userId);
    await _progressBox?.delete(userId);
  }

  /// Get box size (for debugging)
  int getBoxSize(String boxName) {
    switch (boxName) {
      case AppConstants.boxNameUser:
        return _userBox?.length ?? 0;
      case AppConstants.boxNameProgress:
        return _progressBox?.length ?? 0;
      case AppConstants.boxNameLessons:
        return _lessonsBox?.length ?? 0;
      case AppConstants.boxNameSettings:
        return _settingsBox?.length ?? 0;
      default:
        return 0;
    }
  }

  /// Check if data exists
  bool hasData(String boxName, String key) {
    switch (boxName) {
      case AppConstants.boxNameUser:
        return _userBox?.containsKey(key) ?? false;
      case AppConstants.boxNameProgress:
        return _progressBox?.containsKey(key) ?? false;
      case AppConstants.boxNameLessons:
        return _lessonsBox?.containsKey(key) ?? false;
      case AppConstants.boxNameSettings:
        return _settingsBox?.containsKey(key) ?? false;
      default:
        return false;
    }
  }

  /// Close all boxes
  Future<void> closeBoxes() async {
    await _userBox?.close();
    await _progressBox?.close();
    await _lessonsBox?.close();
    await _settingsBox?.close();
  }
}
