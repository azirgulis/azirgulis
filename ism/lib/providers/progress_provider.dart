import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/progress_model.dart';
import '../services/firestore/firestore_service.dart';
import '../core/constants/app_constants.dart';
import 'auth_provider.dart';

part 'progress_provider.g.dart';

// User progress provider
@riverpod
class UserProgress extends _$UserProgress {
  @override
  Future<ProgressModel?> build() async {
    final user = await ref.watch(currentUserProvider.future);
    if (user == null) return null;

    final firestoreService = ref.watch(firestoreServiceProvider);
    final progressData = await firestoreService.getProgress(user.id);

    if (progressData == null) return null;

    return ProgressModel.fromJson(progressData);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(currentUserProvider.future);
      if (user == null) return null;

      final firestoreService = ref.read(firestoreServiceProvider);
      final progressData = await firestoreService.getProgress(user.id);

      if (progressData == null) return null;

      return ProgressModel.fromJson(progressData);
    });
  }

  // Add XP and check for level up
  Future<Map<String, dynamic>> addXP(int amount) async {
    final progress = state.value;
    if (progress == null) return {'leveledUp': false, 'newLevel': 1};

    final user = await ref.read(currentUserProvider.future);
    if (user == null) return {'leveledUp': false, 'newLevel': 1};

    final newXP = progress.xp + amount;
    final newLevel = _calculateLevel(newXP);
    final leveledUp = newLevel > progress.level;

    final firestoreService = ref.read(firestoreServiceProvider);

    if (leveledUp) {
      await firestoreService.updateLevel(user.id, newLevel);
    }

    await firestoreService.addXP(user.id, amount);

    // Refresh state
    await refresh();

    return {
      'leveledUp': leveledUp,
      'newLevel': newLevel,
      'xpAdded': amount,
    };
  }

  // Add coins
  Future<void> addCoins(int amount) async {
    final user = await ref.read(currentUserProvider.future);
    if (user == null) return;

    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.addCoins(user.id, amount);
    await refresh();
  }

  // Add gems
  Future<void> addGems(int amount) async {
    final user = await ref.read(currentUserProvider.future);
    if (user == null) return;

    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.addGems(user.id, amount);
    await refresh();
  }

  // Spend coins
  Future<bool> spendCoins(int amount) async {
    final progress = state.value;
    if (progress == null || progress.coins < amount) return false;

    final user = await ref.read(currentUserProvider.future);
    if (user == null) return false;

    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.addCoins(user.id, -amount);
    await refresh();

    return true;
  }

  // Spend gems
  Future<bool> spendGems(int amount) async {
    final progress = state.value;
    if (progress == null || progress.gems < amount) return false;

    final user = await ref.read(currentUserProvider.future);
    if (user == null) return false;

    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.addGems(user.id, -amount);
    await refresh();

    return true;
  }

  // Complete lesson
  Future<void> completeLesson(String pillar, int lessonNumber) async {
    final user = await ref.read(currentUserProvider.future);
    if (user == null) return;

    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.completeLesson(user.id, pillar, lessonNumber);

    // Award rewards
    await addXP(AppConstants.coinsPerLesson);
    await addCoins(AppConstants.coinsPerLesson);

    await refresh();
  }

  // Save quiz result
  Future<void> saveQuizResult(
    String pillar,
    int lessonNumber,
    QuizResult quizResult,
  ) async {
    final user = await ref.read(currentUserProvider.future);
    if (user == null) return;

    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.saveQuizResult(
      user.id,
      pillar,
      lessonNumber,
      quizResult.toJson(),
    );

    // Award rewards
    await addXP(quizResult.xpEarned);
    await addCoins(quizResult.coinsEarned);
    if (quizResult.gemsEarned > 0) {
      await addGems(quizResult.gemsEarned);
    }

    await refresh();
  }

  // Update daily streak
  Future<void> updateDailyStreak() async {
    final progress = state.value;
    if (progress == null) return;

    final user = await ref.read(currentUserProvider.future);
    if (user == null) return;

    final now = DateTime.now();
    final lastLogin = progress.lastLoginDate;

    int newStreak = progress.dailyStreak;

    if (lastLogin == null) {
      // First login
      newStreak = 1;
    } else {
      final daysSinceLastLogin = now.difference(lastLogin).inDays;

      if (daysSinceLastLogin == 1) {
        // Consecutive day
        newStreak = progress.dailyStreak + 1;
      } else if (daysSinceLastLogin > 1) {
        // Streak broken
        newStreak = 1;
      }
      // If daysSinceLastLogin == 0, same day - keep streak
    }

    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.saveProgress(user.id, {
      'dailyStreak': newStreak,
      'lastLoginDate': now.toIso8601String(),
    });

    // Award daily login coins
    if (lastLogin == null || now.difference(lastLogin).inDays >= 1) {
      await addCoins(AppConstants.dailyLoginCoins);
    }

    await refresh();
  }

  // Calculate level based on XP
  int _calculateLevel(int xp) {
    // Formula: Each level requires more XP (exponential growth)
    // Level 1: 0-100 XP
    // Level 2: 100-250 XP
    // Level 3: 250-450 XP
    // etc.
    int level = 1;
    int xpRequired = 0;
    int baseXP = AppConstants.xpPerLevel;

    while (xp >= xpRequired) {
      xpRequired += baseXP + (level * 25); // Increases by 25 per level
      if (xp >= xpRequired) {
        level++;
      }

      if (level >= AppConstants.maxLevel) {
        return AppConstants.maxLevel;
      }
    }

    return level;
  }

  // Calculate XP needed for next level
  int getXPForNextLevel() {
    final progress = state.value;
    if (progress == null) return AppConstants.xpPerLevel;

    int level = progress.level;
    int xpRequired = 0;
    int baseXP = AppConstants.xpPerLevel;

    for (int i = 1; i <= level; i++) {
      xpRequired += baseXP + (i * 25);
    }

    return xpRequired;
  }

  // Get current level progress percentage
  double getLevelProgress() {
    final progress = state.value;
    if (progress == null) return 0.0;

    final currentXP = progress.xp;
    final currentLevelXP = _getXPForLevel(progress.level - 1);
    final nextLevelXP = _getXPForLevel(progress.level);

    final progressXP = currentXP - currentLevelXP;
    final requiredXP = nextLevelXP - currentLevelXP;

    if (requiredXP == 0) return 1.0;

    return (progressXP / requiredXP).clamp(0.0, 1.0);
  }

  int _getXPForLevel(int level) {
    int xpRequired = 0;
    int baseXP = AppConstants.xpPerLevel;

    for (int i = 1; i <= level; i++) {
      xpRequired += baseXP + (i * 25);
    }

    return xpRequired;
  }
}
