import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../providers/lesson_provider.dart';
import '../../../../providers/progress_provider.dart';
import '../widgets/lesson_card.dart';

class EconomicsHomeScreen extends ConsumerWidget {
  const EconomicsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessons = ref.watch(pillarLessonsProvider('economics'));
    final progressAsync = ref.watch(userProgressProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Economics Tower',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Color.fromARGB(128, 0, 0, 0),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: AppColors.economicsGradient,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.trending_up,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),

          // Progress Summary
          SliverToBoxAdapter(
            child: progressAsync.when(
              data: (progress) {
                if (progress == null) return const SizedBox();

                final economicsProgress =
                    progress.pillarProgress['economics'];
                final completedLessons =
                    economicsProgress?.lessonsCompleted ?? 0;
                final totalLessons = lessons.length;
                final percentage = totalLessons > 0
                    ? (completedLessons / totalLessons * 100).toInt()
                    : 0;

                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.economicsColor.withOpacity(0.1),
                        AppColors.economicsColor.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.economicsColor.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.school,
                            color: AppColors.economicsColor,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your Progress',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  '$completedLessons of $totalLessons lessons completed',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '$percentage%',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: AppColors.economicsColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: totalLessons > 0
                              ? completedLessons / totalLessons
                              : 0,
                          minHeight: 8,
                          backgroundColor: Colors.grey.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.economicsColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
          ),

          // Mini-Games Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.games, color: AppColors.economicsColor),
                      const SizedBox(width: 8),
                      Text(
                        'Mini-Games',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMiniGameCard(
                          context,
                          'Market Matcher',
                          'Match scenarios to supply/demand shifts',
                          Icons.swap_horiz,
                          () => context.push('/economics/games/market-matcher'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMiniGameCard(
                          context,
                          'Inflation Station',
                          'Calculate prices with inflation',
                          Icons.trending_up,
                          () => context.push('/economics/games/inflation-station'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Lessons Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                children: [
                  Icon(Icons.school, color: AppColors.economicsColor),
                  const SizedBox(width: 8),
                  Text(
                    'Lessons',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),

          // Lessons List
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final lesson = lessons[index];
                  return LessonCard(
                    lesson: lesson,
                    pillarColor: AppColors.economicsColor,
                    onTap: () {
                      context.push(
                        '/economics/lesson/${lesson.lessonNumber}',
                      );
                    },
                  );
                },
                childCount: lessons.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniGameCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback? onTap,
  ) {
    final isLocked = onTap == null;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: isLocked
                ? null
                : LinearGradient(
                    colors: [
                      AppColors.economicsColor.withOpacity(0.1),
                      AppColors.economicsColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isLocked
                      ? Colors.grey.withOpacity(0.2)
                      : AppColors.economicsColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isLocked ? Icons.lock : icon,
                  color: isLocked ? Colors.grey : AppColors.economicsColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isLocked ? Colors.grey : null,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isLocked ? Colors.grey : null,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
