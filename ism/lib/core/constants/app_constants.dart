/// App-wide constants for the ISM application
class AppConstants {
  // App Info
  static const String appName = 'ISM';
  static const String appTagline = 'Build Your Business Empire';
  static const String appVersion = '1.0.0';

  // Gamification
  static const int maxLevel = 50;
  static const int xpPerLevel = 100; // Base XP, increases per level
  static const int coinsPerLesson = 50;
  static const int coinsPerQuiz = 100;
  static const int coinsPerMiniGame = 75;
  static const int gemsPerPerfectQuiz = 5;
  static const int dailyLoginCoins = 20;

  // Content
  static const int lessonsPerPillar = 10;
  static const int questionsPerQuiz = 5;
  static const int totalPillars = 4;

  // Unlocks
  static const int levelForApplicationHub = 25;
  static const int levelForFirstTour = 10;
  static const int levelForSecondTour = 25;
  static const int levelForCertificate = 50;

  // Social
  static const int maxFriends = 100;
  static const int leaderboardTopCount = 100;

  // Simulation
  static const int simulationDays = 30;

  // Storage Keys
  static const String boxNameUser = 'user_box';
  static const String boxNameProgress = 'progress_box';
  static const String boxNameLessons = 'lessons_box';
  static const String boxNameSettings = 'settings_box';

  // SharedPreferences Keys
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keySelectedLanguage = 'selected_language';
  static const String keyThemeMode = 'theme_mode';
  static const String keyNotificationsEnabled = 'notifications_enabled';

  // Animation Durations
  static const Duration animationShort = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 400);
  static const Duration animationLong = Duration(milliseconds: 600);

  // API Endpoints (placeholder)
  static const String newsApiUrl = 'https://newsapi.org/v2';
  static const String stockApiUrl = 'https://www.alphavantage.co';

  // Assets Paths
  static const String imagesPath = 'assets/images/';
  static const String videosPath = 'assets/videos/';
  static const String animationsPath = 'assets/animations/';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String progressCollection = 'progress';
  static const String leaderboardCollection = 'leaderboard';
  static const String achievementsCollection = 'achievements';
  static const String challengesCollection = 'challenges';
}
