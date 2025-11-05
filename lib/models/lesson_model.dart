import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_model.freezed.dart';
part 'lesson_model.g.dart';

@freezed
class LessonModel with _$LessonModel {
  const factory LessonModel({
    required String id,
    required String pillarId, // economics, management, business, marketing
    required int lessonNumber,
    required String title,
    required String description,
    required String content,
    @Default([]) List<LessonSection> sections,
    @Default('beginner') String difficulty,
    @Default(10) int estimatedMinutes,
    @Default([]) List<String> learningObjectives,
    @Default([]) List<String> keyTerms,
    String? videoUrl,
    @Default([]) List<String> imageUrls,
    @Default(50) int coinsReward,
    @Default(100) int xpReward,
    @Default(false) bool requiresPreviousLesson,
    int? prerequisiteLessonNumber,
  }) = _LessonModel;

  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);
}

@freezed
class LessonSection with _$LessonSection {
  const factory LessonSection({
    required String title,
    required String content,
    required LessonSectionType type,
    String? imageUrl,
    String? videoUrl,
    Map<String, dynamic>? interactiveData,
  }) = _LessonSection;

  factory LessonSection.fromJson(Map<String, dynamic> json) =>
      _$LessonSectionFromJson(json);
}

enum LessonSectionType {
  text,
  video,
  image,
  interactive,
  quiz,
  example,
  keyTakeaway,
}

@freezed
class Quiz with _$Quiz {
  const factory Quiz({
    required String id,
    required String lessonId,
    required String pillarId,
    required int lessonNumber,
    @Default([]) List<QuizQuestion> questions,
    @Default(5) int totalQuestions,
    @Default(60) int timeLimit, // seconds per question, 0 for no limit
    @Default(80) int passingScore, // percentage
  }) = _Quiz;

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
}

@freezed
class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required String id,
    required String question,
    required QuizQuestionType type,
    required List<String> options,
    required dynamic correctAnswer, // String for single, List<String> for multiple
    String? explanation,
    String? imageUrl,
    @Default(1) int points,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}

enum QuizQuestionType {
  multipleChoice,
  trueFalse,
  dragAndDrop,
  fillInBlank,
  matching,
}
