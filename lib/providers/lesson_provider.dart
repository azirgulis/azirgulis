import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/lesson_model.dart';
import '../data/lessons/economics_lessons.dart';
import '../data/lessons/management_lessons.dart';
import '../data/lessons/business_lessons.dart';
import '../data/lessons/marketing_lessons.dart';

part 'lesson_provider.g.dart';

// Get all lessons for a pillar
@riverpod
List<LessonModel> pillarLessons(PillarLessonsRef ref, String pillarId) {
  switch (pillarId) {
    case 'economics':
      return EconomicsLessons.getAllLessons();
    case 'management':
      return ManagementLessons.getAllLessons();
    case 'business':
      return BusinessLessons.getAllLessons();
    case 'marketing':
      return MarketingLessons.getAllLessons();
    default:
      return [];
  }
}

// Get specific lesson
@riverpod
LessonModel? getLesson(
  GetLessonRef ref,
  String pillarId,
  int lessonNumber,
) {
  final lessons = ref.watch(pillarLessonsProvider(pillarId));
  try {
    return lessons.firstWhere((lesson) => lesson.lessonNumber == lessonNumber);
  } catch (e) {
    return null;
  }
}

// Get quiz for a lesson
@riverpod
Quiz? getLessonQuiz(GetLessonQuizRef ref, String pillarId, int lessonNumber) {
  switch (pillarId) {
    case 'economics':
      return EconomicsLessons.getQuiz(lessonNumber);
    case 'management':
      return ManagementLessons.getQuiz(lessonNumber);
    case 'business':
      return BusinessLessons.getQuiz(lessonNumber);
    case 'marketing':
      return MarketingLessons.getQuiz(lessonNumber);
    default:
      return null;
  }
}
