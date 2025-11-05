import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../providers/lesson_provider.dart';
import '../../../../providers/progress_provider.dart';
import '../../../../models/lesson_model.dart';
import '../../../../models/progress_model.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final int lessonNumber;

  const QuizScreen({
    super.key,
    required this.lessonNumber,
  });

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _currentQuestionIndex = 0;
  Map<int, String> _selectedAnswers = {};
  bool _isAnswered = false;
  int _correctAnswers = 0;

  @override
  Widget build(BuildContext context) {
    final quizAsync = ref.watch(
      getLessonQuizProvider('economics', widget.lessonNumber),
    );

    if (quizAsync == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(
          child: Text('Quiz not available for this lesson.'),
        ),
      );
    }

    final quiz = quizAsync;
    final questions = quiz.questions;

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(
          child: Text('This quiz has no questions yet.'),
        ),
      );
    }

    final currentQuestion = questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / questions.length;

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit Quiz?'),
            content: const Text(
              'Your progress will be lost. Are you sure you want to exit?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.errorRed,
                ),
                child: const Text('Exit'),
              ),
            ],
          ),
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lesson ${widget.lessonNumber} Quiz'),
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
        body: Column(
          children: [
            // Question Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.economicsGradient,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${_currentQuestionIndex + 1} of ${questions.length}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      currentQuestion.question,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Question Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Answer Options
                    ...currentQuestion.options.asMap().entries.map((entry) {
                      final index = entry.key;
                      final option = entry.value;
                      final isSelected =
                          _selectedAnswers[_currentQuestionIndex] == option;
                      final isCorrect = option == currentQuestion.correctAnswer;

                      Color? backgroundColor;
                      Color? borderColor;
                      IconData? icon;

                      if (_isAnswered) {
                        if (isCorrect) {
                          backgroundColor = AppColors.successGreen.withOpacity(0.1);
                          borderColor = AppColors.successGreen;
                          icon = Icons.check_circle;
                        } else if (isSelected) {
                          backgroundColor = AppColors.errorRed.withOpacity(0.1);
                          borderColor = AppColors.errorRed;
                          icon = Icons.cancel;
                        }
                      } else if (isSelected) {
                        backgroundColor = AppColors.economicsColor.withOpacity(0.1);
                        borderColor = AppColors.economicsColor;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: _isAnswered
                              ? null
                              : () {
                                  setState(() {
                                    _selectedAnswers[_currentQuestionIndex] = option;
                                  });
                                },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: backgroundColor ??
                                  Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: borderColor ??
                                    Colors.grey.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: borderColor?.withOpacity(0.2) ??
                                        Colors.grey.withOpacity(0.2),
                                  ),
                                  child: Center(
                                    child: icon != null
                                        ? Icon(icon, color: borderColor, size: 20)
                                        : Text(
                                            String.fromCharCode(65 + index), // A, B, C, D
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: borderColor ?? Colors.grey[700],
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    // Explanation (shown after answering)
                    if (_isAnswered && currentQuestion.explanation != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.infoBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.infoBlue.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb,
                                  color: AppColors.infoBlue,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Explanation',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currentQuestion.explanation!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Bottom Action Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: _isAnswered
                    ? ElevatedButton(
                        onPressed: _handleNext,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.economicsColor,
                        ),
                        child: Text(
                          _currentQuestionIndex == questions.length - 1
                              ? 'See Results'
                              : 'Next Question',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _selectedAnswers.containsKey(_currentQuestionIndex)
                            ? _handleSubmitAnswer
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.economicsColor,
                        ),
                        child: const Text(
                          'Submit Answer',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitAnswer() {
    setState(() {
      _isAnswered = true;

      // Check if answer is correct
      final currentQuestion =
          ref.read(getLessonQuizProvider('economics', widget.lessonNumber))!
              .questions[_currentQuestionIndex];

      if (_selectedAnswers[_currentQuestionIndex] ==
          currentQuestion.correctAnswer) {
        _correctAnswers++;
      }
    });
  }

  void _handleNext() async {
    final questions =
        ref.read(getLessonQuizProvider('economics', widget.lessonNumber))!
            .questions;

    if (_currentQuestionIndex < questions.length - 1) {
      // Move to next question
      setState(() {
        _currentQuestionIndex++;
        _isAnswered = false;
      });
    } else {
      // Quiz completed - calculate results and save
      final totalQuestions = questions.length;
      final score = (_correctAnswers / totalQuestions * 100).round();
      final isPerfect = _correctAnswers == totalQuestions;

      // Calculate rewards
      int xpEarned = 100; // Base XP
      int coinsEarned = 100; // Base coins
      int gemsEarned = 0;

      if (isPerfect) {
        xpEarned *= 2; // Double XP for perfect score
        gemsEarned = 5; // Bonus gems
      } else if (score >= 80) {
        xpEarned = (xpEarned * 1.5).round();
      }

      // Create quiz result
      final quizResult = QuizResult(
        lessonNumber: widget.lessonNumber,
        score: score,
        totalQuestions: totalQuestions,
        correctAnswers: _correctAnswers,
        completedAt: DateTime.now(),
        isPerfectScore: isPerfect,
        xpEarned: xpEarned,
        coinsEarned: coinsEarned,
        gemsEarned: gemsEarned,
      );

      // Save quiz result
      await ref.read(userProgressProvider.notifier).saveQuizResult(
            'economics',
            widget.lessonNumber,
            quizResult,
          );

      if (mounted) {
        // Navigate to results screen
        context.pushReplacement(
          '/economics/lesson/${widget.lessonNumber}/quiz/results',
          extra: {
            'correctAnswers': _correctAnswers,
            'totalQuestions': totalQuestions,
            'score': score,
            'xpEarned': xpEarned,
            'coinsEarned': coinsEarned,
            'gemsEarned': gemsEarned,
            'isPerfect': isPerfect,
          },
        );
      }
    }
  }
}
