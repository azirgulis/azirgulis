import '../../models/lesson_model.dart';

class ManagementLessons {
  static List<LessonModel> getAllLessons() {
    return List.generate(
      10,
      (index) => LessonModel(
        id: 'mgmt_${index + 1}',
        pillarId: 'management',
        lessonNumber: index + 1,
        title: 'Management Lesson ${index + 1}',
        description: 'Management content coming soon',
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
      id: 'mgmt_quiz_$lessonNumber',
      lessonId: 'mgmt_$lessonNumber',
      pillarId: 'management',
      lessonNumber: lessonNumber,
      questions: const [],
    );
  }
}
