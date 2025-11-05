import 'package:freezed_annotation/freezed_annotation.dart';

part 'achievement_model.freezed.dart';
part 'achievement_model.g.dart';

@freezed
class AchievementModel with _$AchievementModel {
  const factory AchievementModel({
    required String id,
    required String title,
    required String description,
    required AchievementCategory category,
    required AchievementRarity rarity,
    required String iconName,
    @Default(0) int coinsReward,
    @Default(0) int gemsReward,
    @Default(0) int xpReward,
    required AchievementCriteria criteria,
    @Default(false) bool isSecret,
  }) = _AchievementModel;

  factory AchievementModel.fromJson(Map<String, dynamic> json) =>
      _$AchievementModelFromJson(json);
}

enum AchievementCategory {
  subjectMastery,
  levelMilestone,
  quizPerformance,
  social,
  dailyEngagement,
  ismContent,
  miniGameMaster,
  special,
}

enum AchievementRarity {
  common,
  rare,
  epic,
  legendary,
}

@freezed
class AchievementCriteria with _$AchievementCriteria {
  const factory AchievementCriteria({
    required AchievementCriteriaType type,
    required int targetValue,
    @Default(0) int currentValue,
    Map<String, dynamic>? additionalData,
  }) = _AchievementCriteria;

  factory AchievementCriteria.fromJson(Map<String, dynamic> json) =>
      _$AchievementCriteriaFromJson(json);
}

enum AchievementCriteriaType {
  reachLevel,
  completeLessons,
  perfectQuizzes,
  addFriends,
  loginStreak,
  watchVideos,
  completePillar,
  earnCoins,
  earnGems,
  winChallenges,
}

@freezed
class UnlockedAchievement with _$UnlockedAchievement {
  const factory UnlockedAchievement({
    required String achievementId,
    required DateTime unlockedAt,
    @Default(false) bool hasBeenViewed,
  }) = _UnlockedAchievement;

  factory UnlockedAchievement.fromJson(Map<String, dynamic> json) =>
      _$UnlockedAchievementFromJson(json);
}
