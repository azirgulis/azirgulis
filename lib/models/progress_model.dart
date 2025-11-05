import 'package:freezed_annotation/freezed_annotation.dart';

part 'progress_model.freezed.dart';
part 'progress_model.g.dart';

@freezed
class ProgressModel with _$ProgressModel {
  const factory ProgressModel({
    required String userId,
    @Default(1) int level,
    @Default(0) int xp,
    @Default(0) int coins,
    @Default(0) int gems,
    @Default(0) int dailyStreak,
    DateTime? lastLoginDate,
    @Default({}) Map<String, PillarProgress> pillarProgress,
    @Default([]) List<String> unlockedAchievements,
    @Default([]) List<String> completedChallenges,
    @Default(0) int totalLessonsCompleted,
    @Default(0) int totalQuizzesTaken,
    @Default(0) int totalMiniGamesPlayed,
    @Default(0.0) double averageQuizScore,
    DateTime? lastUpdated,
  }) = _ProgressModel;

  factory ProgressModel.fromJson(Map<String, dynamic> json) =>
      _$ProgressModelFromJson(json);
}

@freezed
class PillarProgress with _$PillarProgress {
  const factory PillarProgress({
    required String pillarId, // economics, management, business, marketing
    @Default(0) int lessonsCompleted,
    @Default(0) int quizzesCompleted,
    @Default(0) int miniGamesCompleted,
    @Default([]) List<int> completedLessonNumbers,
    @Default({}) Map<String, QuizResult> quizResults,
    @Default(0.0) double averageScore,
    @Default(0) int totalTimeSpentMinutes,
    @Default(false) bool isPillarCompleted,
  }) = _PillarProgress;

  factory PillarProgress.fromJson(Map<String, dynamic> json) =>
      _$PillarProgressFromJson(json);
}

@freezed
class QuizResult with _$QuizResult {
  const factory QuizResult({
    required int lessonNumber,
    required int score,
    required int totalQuestions,
    required int correctAnswers,
    required DateTime completedAt,
    @Default(0) int timeSpentSeconds,
    @Default(false) bool isPerfectScore,
    @Default(0) int xpEarned,
    @Default(0) int coinsEarned,
    @Default(0) int gemsEarned,
  }) = _QuizResult;

  factory QuizResult.fromJson(Map<String, dynamic> json) =>
      _$QuizResultFromJson(json);
}

@freezed
class DailyStats with _$DailyStats {
  const factory DailyStats({
    required DateTime date,
    @Default(0) int xpEarned,
    @Default(0) int lessonsCompleted,
    @Default(0) int quizzesTaken,
    @Default(0) int timeSpentMinutes,
  }) = _DailyStats;

  factory DailyStats.fromJson(Map<String, dynamic> json) =>
      _$DailyStatsFromJson(json);
}
