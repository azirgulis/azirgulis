import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/achievement_model.dart';
import '../../models/progress_model.dart';
import '../../data/achievements/achievement_definitions.dart';

class AchievementService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Check all achievements for a user and return newly unlocked ones
  Future<List<AchievementModel>> checkAchievements({
    required String userId,
    required ProgressModel progress,
    Map<String, dynamic>? additionalContext,
  }) async {
    final List<AchievementModel> newlyUnlocked = [];

    // Get user's currently unlocked achievements
    final unlockedIds = await getUnlockedAchievementIds(userId);

    // Check each achievement
    for (final achievement in AchievementDefinitions.getAllAchievements()) {
      // Skip if already unlocked
      if (unlockedIds.contains(achievement.id)) continue;

      // Check if criteria is met
      if (_checkCriteria(achievement, progress, additionalContext)) {
        await _unlockAchievement(userId, achievement, progress);
        newlyUnlocked.add(achievement);
      }
    }

    return newlyUnlocked;
  }

  /// Check a specific achievement type (for targeted checks)
  Future<List<AchievementModel>> checkSpecificAchievements({
    required String userId,
    required ProgressModel progress,
    required AchievementCriteriaType criteriaType,
    Map<String, dynamic>? additionalContext,
  }) async {
    final List<AchievementModel> newlyUnlocked = [];

    final unlockedIds = await getUnlockedAchievementIds(userId);

    for (final achievement in AchievementDefinitions.getAllAchievements()) {
      if (unlockedIds.contains(achievement.id)) continue;
      if (achievement.criteria.type != criteriaType) continue;

      if (_checkCriteria(achievement, progress, additionalContext)) {
        await _unlockAchievement(userId, achievement, progress);
        newlyUnlocked.add(achievement);
      }
    }

    return newlyUnlocked;
  }

  /// Check if achievement criteria is met
  bool _checkCriteria(
    AchievementModel achievement,
    ProgressModel progress,
    Map<String, dynamic>? context,
  ) {
    final criteria = achievement.criteria;

    switch (criteria.type) {
      case AchievementCriteriaType.reachLevel:
        return progress.level >= criteria.targetValue;

      case AchievementCriteriaType.earnCoins:
        return progress.coins >= criteria.targetValue;

      case AchievementCriteriaType.earnGems:
        return progress.gems >= criteria.targetValue;

      case AchievementCriteriaType.completeLessons:
        if (criteria.pillarId != null) {
          final pillarProgress = progress.pillarProgress[criteria.pillarId];
          return (pillarProgress?.lessonsCompleted ?? 0) >= criteria.targetValue;
        }
        // Total lessons across all pillars
        return progress.pillarProgress.values
            .fold(0, (sum, p) => sum + p.lessonsCompleted) >= criteria.targetValue;

      case AchievementCriteriaType.completeQuizzes:
        if (criteria.pillarId != null) {
          final pillarProgress = progress.pillarProgress[criteria.pillarId];
          return (pillarProgress?.quizzesCompleted ?? 0) >= criteria.targetValue;
        }
        return progress.pillarProgress.values
            .fold(0, (sum, p) => sum + p.quizzesCompleted) >= criteria.targetValue;

      case AchievementCriteriaType.perfectScore:
        // Check context for recent perfect score
        return context?['isPerfect'] == true;

      case AchievementCriteriaType.perfectScoreStreak:
        return (context?['perfectScoreStreak'] ?? 0) >= criteria.targetValue;

      case AchievementCriteriaType.dailyStreak:
        return progress.dailyStreak >= criteria.targetValue;

      case AchievementCriteriaType.loginStreak:
        return progress.loginStreak >= criteria.targetValue;

      case AchievementCriteriaType.addFriends:
        // This would need to check friends count from context
        return (context?['friendsCount'] ?? 0) >= criteria.targetValue;

      case AchievementCriteriaType.winChallenges:
        // This would need to check challenge wins from context
        return (context?['challengeWins'] ?? 0) >= criteria.targetValue;

      case AchievementCriteriaType.completeMiniGames:
        if (criteria.miniGameId != null) {
          return context?['completedMiniGame'] == criteria.miniGameId;
        }
        return (context?['miniGamesCompleted'] ?? 0) >= criteria.targetValue;

      case AchievementCriteriaType.leaderboardRank:
        return (context?['leaderboardRank'] ?? 999999) <= criteria.targetValue;

      case AchievementCriteriaType.watchVideos:
        return (context?['videosWatched'] ?? 0) >= criteria.targetValue;

      case AchievementCriteriaType.readArticles:
        return (context?['articlesRead'] ?? 0) >= criteria.targetValue;

      case AchievementCriteriaType.customEvent:
        // Custom events need to be checked in context
        return context?[criteria.customEventId ?? ''] == true;
    }
  }

  /// Unlock an achievement and save to Firestore
  Future<void> _unlockAchievement(
    String userId,
    AchievementModel achievement,
    ProgressModel progress,
  ) async {
    final unlockedAt = DateTime.now();

    // Create achievement unlock record
    final unlockData = {
      'achievementId': achievement.id,
      'userId': userId,
      'unlockedAt': Timestamp.fromDate(unlockedAt),
      'title': achievement.title,
      'description': achievement.description,
      'category': achievement.category.toString(),
      'rarity': achievement.rarity.toString(),
      'coinsReward': achievement.coinsReward,
      'xpReward': achievement.xpReward,
      'gemsReward': achievement.gemsReward,
    };

    // Save to user's achievements subcollection
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('achievements')
        .doc(achievement.id)
        .set(unlockData);

    // Award rewards to user progress
    final batch = _firestore.batch();

    final progressRef = _firestore.collection('progress').doc(userId);
    batch.update(progressRef, {
      'coins': FieldValue.increment(achievement.coinsReward),
      'xp': FieldValue.increment(achievement.xpReward),
      'gems': FieldValue.increment(achievement.gemsReward),
      'achievementsUnlocked': FieldValue.increment(1),
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  /// Get all unlocked achievement IDs for a user
  Future<Set<String>> getUnlockedAchievementIds(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('achievements')
        .get();

    return snapshot.docs.map((doc) => doc.id).toSet();
  }

  /// Get all unlocked achievements with details
  Future<List<Map<String, dynamic>>> getUnlockedAchievements(
    String userId,
  ) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('achievements')
        .orderBy('unlockedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Get achievement unlock progress for a specific achievement
  double getAchievementProgress(
    AchievementModel achievement,
    ProgressModel progress,
    Map<String, dynamic>? context,
  ) {
    final criteria = achievement.criteria;

    switch (criteria.type) {
      case AchievementCriteriaType.reachLevel:
        return (progress.level / criteria.targetValue).clamp(0.0, 1.0);

      case AchievementCriteriaType.earnCoins:
        return (progress.coins / criteria.targetValue).clamp(0.0, 1.0);

      case AchievementCriteriaType.earnGems:
        return (progress.gems / criteria.targetValue).clamp(0.0, 1.0);

      case AchievementCriteriaType.completeLessons:
        if (criteria.pillarId != null) {
          final pillarProgress = progress.pillarProgress[criteria.pillarId];
          final completed = pillarProgress?.lessonsCompleted ?? 0;
          return (completed / criteria.targetValue).clamp(0.0, 1.0);
        }
        final totalLessons = progress.pillarProgress.values
            .fold(0, (sum, p) => sum + p.lessonsCompleted);
        return (totalLessons / criteria.targetValue).clamp(0.0, 1.0);

      case AchievementCriteriaType.completeQuizzes:
        if (criteria.pillarId != null) {
          final pillarProgress = progress.pillarProgress[criteria.pillarId];
          final completed = pillarProgress?.quizzesCompleted ?? 0;
          return (completed / criteria.targetValue).clamp(0.0, 1.0);
        }
        final totalQuizzes = progress.pillarProgress.values
            .fold(0, (sum, p) => sum + p.quizzesCompleted);
        return (totalQuizzes / criteria.targetValue).clamp(0.0, 1.0);

      case AchievementCriteriaType.dailyStreak:
        return (progress.dailyStreak / criteria.targetValue).clamp(0.0, 1.0);

      case AchievementCriteriaType.loginStreak:
        return (progress.loginStreak / criteria.targetValue).clamp(0.0, 1.0);

      case AchievementCriteriaType.addFriends:
        final friendsCount = context?['friendsCount'] ?? 0;
        return (friendsCount / criteria.targetValue).clamp(0.0, 1.0);

      case AchievementCriteriaType.winChallenges:
        final wins = context?['challengeWins'] ?? 0;
        return (wins / criteria.targetValue).clamp(0.0, 1.0);

      case AchievementCriteriaType.completeMiniGames:
        final completed = context?['miniGamesCompleted'] ?? 0;
        return (completed / criteria.targetValue).clamp(0.0, 1.0);

      case AchievementCriteriaType.watchVideos:
        final watched = context?['videosWatched'] ?? 0;
        return (watched / criteria.targetValue).clamp(0.0, 1.0);

      case AchievementCriteriaType.readArticles:
        final read = context?['articlesRead'] ?? 0;
        return (read / criteria.targetValue).clamp(0.0, 1.0);

      default:
        return 0.0;
    }
  }

  /// Get statistics about user's achievements
  Future<Map<String, dynamic>> getAchievementStats(String userId) async {
    final unlockedAchievements = await getUnlockedAchievements(userId);
    final totalAchievements = AchievementDefinitions.getAllAchievements().length;

    final Map<AchievementCategory, int> byCategory = {};
    final Map<AchievementRarity, int> byRarity = {};

    for (final unlocked in unlockedAchievements) {
      final categoryStr = unlocked['category'] as String;
      final category = AchievementCategory.values.firstWhere(
        (c) => c.toString() == categoryStr,
      );
      byCategory[category] = (byCategory[category] ?? 0) + 1;

      final rarityStr = unlocked['rarity'] as String;
      final rarity = AchievementRarity.values.firstWhere(
        (r) => r.toString() == rarityStr,
      );
      byRarity[rarity] = (byRarity[rarity] ?? 0) + 1;
    }

    return {
      'totalUnlocked': unlockedAchievements.length,
      'totalAchievements': totalAchievements,
      'percentageComplete': (unlockedAchievements.length / totalAchievements * 100).round(),
      'byCategory': byCategory,
      'byRarity': byRarity,
    };
  }
}
