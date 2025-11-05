import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/achievement_model.dart';
import '../models/progress_model.dart';
import '../services/achievements/achievement_service.dart';
import '../data/achievements/achievement_definitions.dart';
import 'auth_provider.dart';
import 'progress_provider.dart';

part 'achievement_provider.g.dart';

/// Provider for achievement service
@riverpod
AchievementService achievementService(AchievementServiceRef ref) {
  return AchievementService();
}

/// Provider for unlocked achievement IDs
@riverpod
class UnlockedAchievements extends _$UnlockedAchievements {
  @override
  Future<Set<String>> build() async {
    final user = ref.watch(currentUserProvider).value;
    if (user == null) return {};

    final service = ref.read(achievementServiceProvider);
    return await service.getUnlockedAchievementIds(user.id);
  }

  /// Refresh unlocked achievements
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(currentUserProvider).value;
      if (user == null) return {};

      final service = ref.read(achievementServiceProvider);
      return await service.getUnlockedAchievementIds(user.id);
    });
  }
}

/// Provider for unlocked achievements with full details
@riverpod
class UnlockedAchievementsDetailed extends _$UnlockedAchievementsDetailed {
  @override
  Future<List<Map<String, dynamic>>> build() async {
    final user = ref.watch(currentUserProvider).value;
    if (user == null) return [];

    final service = ref.read(achievementServiceProvider);
    return await service.getUnlockedAchievements(user.id);
  }

  /// Refresh unlocked achievements
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(currentUserProvider).value;
      if (user == null) return [];

      final service = ref.read(achievementServiceProvider);
      return await service.getUnlockedAchievements(user.id);
    });
  }
}

/// Provider for achievement stats
@riverpod
class AchievementStats extends _$AchievementStats {
  @override
  Future<Map<String, dynamic>> build() async {
    final user = ref.watch(currentUserProvider).value;
    if (user == null) {
      return {
        'totalUnlocked': 0,
        'totalAchievements': AchievementDefinitions.getAllAchievements().length,
        'percentageComplete': 0,
        'byCategory': <AchievementCategory, int>{},
        'byRarity': <AchievementRarity, int>{},
      };
    }

    final service = ref.read(achievementServiceProvider);
    return await service.getAchievementStats(user.id);
  }

  /// Refresh stats
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(currentUserProvider).value;
      if (user == null) {
        return {
          'totalUnlocked': 0,
          'totalAchievements': AchievementDefinitions.getAllAchievements().length,
          'percentageComplete': 0,
          'byCategory': <AchievementCategory, int>{},
          'byRarity': <AchievementRarity, int>{},
        };
      }

      final service = ref.read(achievementServiceProvider);
      return await service.getAchievementStats(user.id);
    });
  }
}

/// Provider for checking and unlocking achievements
@riverpod
class AchievementChecker extends _$AchievementChecker {
  @override
  FutureOr<List<AchievementModel>> build() {
    return [];
  }

  /// Check all achievements for current progress
  Future<List<AchievementModel>> checkAll({
    Map<String, dynamic>? additionalContext,
  }) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return [];

    final progressAsync = ref.read(userProgressProvider);
    if (!progressAsync.hasValue || progressAsync.value == null) return [];

    final progress = progressAsync.value!;
    final service = ref.read(achievementServiceProvider);

    final newlyUnlocked = await service.checkAchievements(
      userId: user.id,
      progress: progress,
      additionalContext: additionalContext,
    );

    if (newlyUnlocked.isNotEmpty) {
      // Refresh unlocked achievements list
      ref.invalidate(unlockedAchievementsProvider);
      ref.invalidate(unlockedAchievementsDetailedProvider);
      ref.invalidate(achievementStatsProvider);

      // Refresh user progress to reflect rewards
      await ref.read(userProgressProvider.notifier).refresh();
    }

    return newlyUnlocked;
  }

  /// Check specific achievement type
  Future<List<AchievementModel>> checkSpecific({
    required AchievementCriteriaType criteriaType,
    Map<String, dynamic>? additionalContext,
  }) async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return [];

    final progressAsync = ref.read(userProgressProvider);
    if (!progressAsync.hasValue || progressAsync.value == null) return [];

    final progress = progressAsync.value!;
    final service = ref.read(achievementServiceProvider);

    final newlyUnlocked = await service.checkSpecificAchievements(
      userId: user.id,
      progress: progress,
      criteriaType: criteriaType,
      additionalContext: additionalContext,
    );

    if (newlyUnlocked.isNotEmpty) {
      ref.invalidate(unlockedAchievementsProvider);
      ref.invalidate(unlockedAchievementsDetailedProvider);
      ref.invalidate(achievementStatsProvider);
      await ref.read(userProgressProvider.notifier).refresh();
    }

    return newlyUnlocked;
  }

  /// Check achievements after completing a lesson
  Future<List<AchievementModel>> checkAfterLesson({
    required String pillarId,
    required int lessonsCompleted,
  }) async {
    return await checkSpecific(
      criteriaType: AchievementCriteriaType.completeLessons,
      additionalContext: {
        'pillarId': pillarId,
        'lessonsCompleted': lessonsCompleted,
      },
    );
  }

  /// Check achievements after completing a quiz
  Future<List<AchievementModel>> checkAfterQuiz({
    required String pillarId,
    required bool isPerfect,
    required int perfectScoreStreak,
    required int quizzesCompleted,
  }) async {
    final List<AchievementModel> allNewAchievements = [];

    // Check quiz completion achievements
    final quizAchievements = await checkSpecific(
      criteriaType: AchievementCriteriaType.completeQuizzes,
      additionalContext: {
        'pillarId': pillarId,
        'quizzesCompleted': quizzesCompleted,
      },
    );
    allNewAchievements.addAll(quizAchievements);

    // Check perfect score achievements
    if (isPerfect) {
      final perfectAchievements = await checkSpecific(
        criteriaType: AchievementCriteriaType.perfectScore,
        additionalContext: {
          'isPerfect': true,
          'perfectScoreStreak': perfectScoreStreak,
        },
      );
      allNewAchievements.addAll(perfectAchievements);
    }

    // Check level achievements (in case quiz XP caused level up)
    final levelAchievements = await checkSpecific(
      criteriaType: AchievementCriteriaType.reachLevel,
    );
    allNewAchievements.addAll(levelAchievements);

    return allNewAchievements;
  }

  /// Check achievements after leveling up
  Future<List<AchievementModel>> checkAfterLevelUp(int newLevel) async {
    return await checkSpecific(
      criteriaType: AchievementCriteriaType.reachLevel,
      additionalContext: {'level': newLevel},
    );
  }

  /// Check achievements after earning coins/gems
  Future<List<AchievementModel>> checkAfterEarning() async {
    final List<AchievementModel> allNewAchievements = [];

    final coinAchievements = await checkSpecific(
      criteriaType: AchievementCriteriaType.earnCoins,
    );
    allNewAchievements.addAll(coinAchievements);

    final gemAchievements = await checkSpecific(
      criteriaType: AchievementCriteriaType.earnGems,
    );
    allNewAchievements.addAll(gemAchievements);

    return allNewAchievements;
  }

  /// Check achievements for login streaks
  Future<List<AchievementModel>> checkLoginStreak(int streak) async {
    return await checkSpecific(
      criteriaType: AchievementCriteriaType.loginStreak,
      additionalContext: {'loginStreak': streak},
    );
  }

  /// Check achievements after completing mini-game
  Future<List<AchievementModel>> checkAfterMiniGame(String miniGameId) async {
    return await checkSpecific(
      criteriaType: AchievementCriteriaType.completeMiniGames,
      additionalContext: {
        'completedMiniGame': miniGameId,
      },
    );
  }
}

/// Provider to get achievement progress for display
@riverpod
double achievementProgress(
  AchievementProgressRef ref,
  AchievementModel achievement,
) {
  final progressAsync = ref.watch(userProgressProvider);
  if (!progressAsync.hasValue || progressAsync.value == null) return 0.0;

  final progress = progressAsync.value!;
  final service = ref.read(achievementServiceProvider);

  return service.getAchievementProgress(achievement, progress, null);
}

/// Provider to check if achievement is unlocked
@riverpod
bool isAchievementUnlocked(
  IsAchievementUnlockedRef ref,
  String achievementId,
) {
  final unlockedAsync = ref.watch(unlockedAchievementsProvider);
  if (!unlockedAsync.hasValue) return false;

  return unlockedAsync.value?.contains(achievementId) ?? false;
}

/// Provider for all achievements organized by category
@riverpod
Map<AchievementCategory, List<AchievementModel>> achievementsByCategory(
  AchievementsByCategoryRef ref,
) {
  final Map<AchievementCategory, List<AchievementModel>> result = {};

  for (final category in AchievementCategory.values) {
    result[category] = AchievementDefinitions.getByCategory(category);
  }

  return result;
}

/// Provider for all achievements organized by rarity
@riverpod
Map<AchievementRarity, List<AchievementModel>> achievementsByRarity(
  AchievementsByRarityRef ref,
) {
  final Map<AchievementRarity, List<AchievementModel>> result = {};

  for (final rarity in AchievementRarity.values) {
    result[rarity] = AchievementDefinitions.getByRarity(rarity);
  }

  return result;
}
