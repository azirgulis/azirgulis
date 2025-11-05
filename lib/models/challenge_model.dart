import 'package:freezed_annotation/freezed_annotation.dart';

part 'challenge_model.freezed.dart';
part 'challenge_model.g.dart';

@freezed
class ChallengeModel with _$ChallengeModel {
  const factory ChallengeModel({
    required String id,
    required String title,
    required String description,
    required ChallengeType type,
    required DateTime startDate,
    required DateTime endDate,
    required ChallengeCriteria criteria,
    @Default({}) Map<String, ChallengeParticipant> participants,
    @Default(0) int coinsReward,
    @Default(0) int gemsReward,
    @Default(0) int xpReward,
    @Default(100) int maxParticipants,
    String? badgeIconName,
  }) = _ChallengeModel;

  factory ChallengeModel.fromJson(Map<String, dynamic> json) =>
      _$ChallengeModelFromJson(json);
}

enum ChallengeType {
  weekly,
  daily,
  special,
  tournament,
}

@freezed
class ChallengeCriteria with _$ChallengeCriteria {
  const factory ChallengeCriteria({
    required ChallengeCriteriaType type,
    required int targetValue,
    String? specificPillar,
    Map<String, dynamic>? additionalData,
  }) = _ChallengeCriteria;

  factory ChallengeCriteria.fromJson(Map<String, dynamic> json) =>
      _$ChallengeCriteriaFromJson(json);
}

enum ChallengeCriteriaType {
  completeLessons,
  earnXP,
  perfectQuizzes,
  fastCompletion,
  accuracyChallenge,
}

@freezed
class ChallengeParticipant with _$ChallengeParticipant {
  const factory ChallengeParticipant({
    required String userId,
    required DateTime joinedAt,
    @Default(0) int score,
    @Default(0) int progress,
    DateTime? lastUpdated,
    @Default(false) bool hasCompleted,
  }) = _ChallengeParticipant;

  factory ChallengeParticipant.fromJson(Map<String, dynamic> json) =>
      _$ChallengeParticipantFromJson(json);
}

@freezed
class LeaderboardEntry with _$LeaderboardEntry {
  const factory LeaderboardEntry({
    required String userId,
    required String username,
    String? displayName,
    String? photoUrl,
    required int totalXP,
    required int level,
    @Default(0) int rank,
    @Default(0) int weeklyXP,
    @Default(0) int monthlyXP,
    @Default({}) Map<String, int> pillarXP,
    DateTime? lastUpdated,
  }) = _LeaderboardEntry;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryFromJson(json);
}
