import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../providers/achievement_provider.dart';
import '../../../../widgets/notifications/achievement_notification.dart';

class QuizResultsScreen extends ConsumerStatefulWidget {
  final int correctAnswers;
  final int totalQuestions;
  final int score;
  final int xpEarned;
  final int coinsEarned;
  final int gemsEarned;
  final bool isPerfect;

  const QuizResultsScreen({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.score,
    required this.xpEarned,
    required this.coinsEarned,
    required this.gemsEarned,
    required this.isPerfect,
  });

  @override
  ConsumerState<QuizResultsScreen> createState() => _QuizResultsScreenState();
}

class _QuizResultsScreenState extends ConsumerState<QuizResultsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _animationController.forward();

    if (widget.isPerfect || widget.score >= 80) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _confettiController.play();
      });
    }

    // Check for achievements after displaying results
    Future.delayed(const Duration(milliseconds: 2000), () {
      _checkAchievements();
    });
  }

  Future<void> _checkAchievements() async {
    if (!mounted) return;

    // Check quiz-related achievements
    final newAchievements = await ref
        .read(achievementCheckerProvider.notifier)
        .checkAfterQuiz(
          pillarId: 'economics',
          isPerfect: widget.isPerfect,
          perfectScoreStreak: 1, // TODO: Track this properly
          quizzesCompleted: 1, // This will be calculated from progress
        );

    // Show notification for each new achievement
    if (mounted && newAchievements.isNotEmpty) {
      for (var i = 0; i < newAchievements.length; i++) {
        final achievement = newAchievements[i];
        // Delay each notification slightly so they don't overlap
        Future.delayed(Duration(milliseconds: i * 4500), () {
          if (mounted) {
            AchievementNotificationOverlay.show(
              context,
              achievement,
              onTap: () => context.push('/achievements'),
            );
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = widget.score;
    final passed = percentage >= 80;

    String title;
    String message;
    Color titleColor;
    IconData icon;

    if (widget.isPerfect) {
      title = '🎉 Perfect Score!';
      message = 'Outstanding! You got every question right!';
      titleColor = AppColors.successGreen;
      icon = Icons.emoji_events;
    } else if (percentage >= 90) {
      title = '⭐ Excellent!';
      message = 'You really mastered this lesson!';
      titleColor = AppColors.successGreen;
      icon = Icons.star;
    } else if (percentage >= 80) {
      title = '✅ Great Job!';
      message = 'You passed with flying colors!';
      titleColor = AppColors.successGreen;
      icon = Icons.check_circle;
    } else if (percentage >= 60) {
      title = '👍 Good Effort!';
      message = 'You\\'re getting there! Review and try again.';
      titleColor = AppColors.warningYellow;
      icon = Icons.thumb_up;
    } else {
      title = '📚 Keep Learning!';
      message = 'Review the lesson and give it another shot!';
      titleColor = AppColors.errorRed;
      icon = Icons.school;
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: passed
                    ? [
                        AppColors.successGreen.withOpacity(0.2),
                        Colors.white,
                      ]
                    : [
                        AppColors.warningYellow.withOpacity(0.2),
                        Colors.white,
                      ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => context.go('/economics'),
                      ),
                      const Text(
                        'Quiz Results',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Icon
                        FadeTransition(
                          opacity: _animationController,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Curves.elasticOut,
                              ),
                            ),
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: titleColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                icon,
                                size: 60,
                                color: titleColor,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Title
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 8),

                        // Message
                        Text(
                          message,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 32),

                        // Score Circle
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Stack(
                            children: [
                              // Background circle
                              Center(
                                child: SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: CircularProgressIndicator(
                                    value: 1.0,
                                    strokeWidth: 12,
                                    backgroundColor: Colors.grey.withOpacity(0.2),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.grey.withOpacity(0.1),
                                    ),
                                  ),
                                ),
                              ),
                              // Progress circle
                              Center(
                                child: SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.0, end: percentage / 100),
                                    duration: const Duration(milliseconds: 1500),
                                    curve: Curves.easeOutCubic,
                                    builder: (context, value, child) {
                                      return CircularProgressIndicator(
                                        value: value,
                                        strokeWidth: 12,
                                        backgroundColor: Colors.transparent,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          titleColor,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // Score text
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TweenAnimationBuilder<int>(
                                      tween: IntTween(begin: 0, end: percentage),
                                      duration: const Duration(milliseconds: 1500),
                                      builder: (context, value, child) {
                                        return Text(
                                          '$value%',
                                          style: TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                            color: titleColor,
                                          ),
                                        );
                                      },
                                    ),
                                    Text(
                                      '${widget.correctAnswers}/${widget.totalQuestions} correct',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Rewards
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Rewards Earned',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildRewardItem(
                                    Icons.stars,
                                    '+${widget.xpEarned}',
                                    'XP',
                                    AppColors.xpGreen,
                                  ),
                                  _buildRewardItem(
                                    Icons.monetization_on,
                                    '+${widget.coinsEarned}',
                                    'Coins',
                                    AppColors.coinGold,
                                  ),
                                  if (widget.gemsEarned > 0)
                                    _buildRewardItem(
                                      Icons.diamond,
                                      '+${widget.gemsEarned}',
                                      'Gems',
                                      AppColors.gemBlue,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        if (widget.isPerfect) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.successGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.successGreen.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.celebration,
                                  color: AppColors.successGreen,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Perfect score! You earned 2x XP and bonus gems!',
                                    style: TextStyle(
                                      color: AppColors.successGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Bottom Buttons
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!passed)
                        OutlinedButton(
                          onPressed: () {
                            // TODO: Implement retake
                            context.pop();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Review Lesson',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (!passed) const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => context.go('/economics'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.economicsColor,
                        ),
                        child: const Text(
                          'Continue Learning',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Confetti
          if (widget.isPerfect || widget.score >= 80)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                particleDrag: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 50,
                gravity: 0.1,
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRewardItem(
    IconData icon,
    String amount,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 32,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          amount,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
