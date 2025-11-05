import '../../models/lesson_model.dart';

class MarketingLessons {
  static List<LessonModel> getAllLessons() {
    return List.generate(
      10,
      (index) => LessonModel(
        id: 'mkt_${index + 1}',
        pillarId: 'marketing',
        lessonNumber: index + 1,
        title: 'Marketing Lesson ${index + 1}',
        description: 'Marketing content coming soon',
        content: 'Full lesson content to be implemented...',
        difficulty: 'intermediate',
        estimatedMinutes: 15,
        learningObjectives: [],
        keyTerms: [],
        requiresPreviousLesson: index > 0,
        prerequisiteLessonNumber: index > 0 ? index : null,
      ),
    );
  }

  static Quiz? getQuiz(int lessonNumber) {
    return Quiz(
      id: 'mkt_quiz_$lessonNumber',
      lessonId: 'mkt_$lessonNumber',
      pillarId: 'marketing',
      lessonNumber: lessonNumber,
      questions: const [],
    );
  }
}
