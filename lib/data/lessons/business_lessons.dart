import '../../models/lesson_model.dart';

class BusinessLessons {
  static List<LessonModel> getAllLessons() {
    return List.generate(
      10,
      (index) => LessonModel(
        id: 'bus_${index + 1}',
        pillarId: 'business',
        lessonNumber: index + 1,
        title: 'Business Lesson ${index + 1}',
        description: 'Business content coming soon',
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
      id: 'bus_quiz_$lessonNumber',
      lessonId: 'bus_$lessonNumber',
      pillarId: 'business',
      lessonNumber: lessonNumber,
      questions: const [],
    );
  }
}
