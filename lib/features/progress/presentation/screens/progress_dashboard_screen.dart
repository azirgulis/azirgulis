import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../providers/progress_provider.dart';
import '../../../../providers/achievement_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class ProgressDashboardScreen extends ConsumerWidget {
  const ProgressDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(userProgressProvider);
    final achievementStatsAsync = ref.watch(achievementStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
      ),
      body: progressAsync.when(
        data: (progress) {
          if (progress == null) {
            return const Center(child: Text('No progress data available'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Level and XP Card
                _buildLevelCard(context, progress),
                const SizedBox(height: 16),

                // Stats Grid
                _buildStatsGrid(context, progress),
                const SizedBox(height: 24),

                // Pillar Progress Section
                _buildSectionHeader(context, 'Learning Progress'),
                const SizedBox(height: 12),
                _buildPillarProgress(context, progress),
                const SizedBox(height: 24),

                // Achievements Section
                _buildSectionHeader(context, 'Achievements'),
                const SizedBox(height: 12),
                achievementStatsAsync.when(
                  data: (stats) => _buildAchievementStats(context, stats),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (_, __) => const SizedBox(),
                ),
                const SizedBox(height: 24),

                // Engagement Section
                _buildSectionHeader(context, 'Engagement'),
                const SizedBox(height: 12),
                _buildEngagementStats(context, progress),
                const SizedBox(height: 24),

                // XP Chart Section
                _buildSectionHeader(context, 'XP to Next Level'),
                const SizedBox(height: 12),
                _buildXPChart(context, progress),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading progress: $error'),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildLevelCard(BuildContext context, progress) {
    final currentLevelXP = AppConstants.getXPForLevel(progress.level);
    final nextLevelXP = AppConstants.getXPForLevel(progress.level + 1);
    final xpInCurrentLevel = progress.xp - currentLevelXP;
    final xpNeededForNextLevel = nextLevelXP - currentLevelXP;
    final levelProgress = xpInCurrentLevel / xpNeededForNextLevel;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level ${progress.level}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Total XP: ${progress.xp}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.workspace_premium,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress to Level ${progress.level + 1}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  Text(
                    '${(levelProgress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: levelProgress,
                  minHeight: 10,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$xpInCurrentLevel / $xpNeededForNextLevel XP',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, progress) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.0,
      children: [
        _buildStatCard(
          context,
          Icons.monetization_on,
          progress.coins.toString(),
          'Coins',
          AppColors.coinsColor,
        ),
        _buildStatCard(
          context,
          Icons.diamond,
          progress.gems.toString(),
          'Gems',
          AppColors.gemsColor,
        ),
        _buildStatCard(
          context,
          Icons.local_fire_department,
          progress.dailyStreak.toString(),
          'Day Streak',
          AppColors.errorRed,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillarProgress(BuildContext context, progress) {
    final pillars = [
      {'id': 'economics', 'name': 'Economics', 'color': AppColors.economicsColor},
      {'id': 'management', 'name': 'Management', 'color': AppColors.managementColor},
      {'id': 'business', 'name': 'Business', 'color': AppColors.businessColor},
      {'id': 'marketing', 'name': 'Marketing', 'color': AppColors.marketingColor},
    ];

    return Column(
      children: pillars.map((pillar) {
        final pillarProgress = progress.pillarProgress[pillar['id']];
        final lessonsCompleted = pillarProgress?.lessonsCompleted ?? 0;
        final totalLessons = 10; // TODO: Get from actual data
        final percentage = totalLessons > 0 ? lessonsCompleted / totalLessons : 0.0;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pillar['name'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: pillar['color'] as Color,
                          ),
                    ),
                    Text(
                      '$lessonsCompleted/$totalLessons',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: percentage,
                    minHeight: 8,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      pillar['color'] as Color,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.quiz,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${pillarProgress?.quizzesCompleted ?? 0} quizzes',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.stars,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${pillarProgress?.totalXPEarned ?? 0} XP',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAchievementStats(BuildContext context, Map<String, dynamic> stats) {
    final totalUnlocked = stats['totalUnlocked'] as int;
    final totalAchievements = stats['totalAchievements'] as int;
    final percentage = stats['percentageComplete'] as int;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.badgeLegendary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.emoji_events,
                        color: AppColors.badgeLegendary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Achievements',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '$totalUnlocked of $totalAchievements unlocked',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.badgeLegendary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 8,
                backgroundColor: Colors.grey.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.badgeLegendary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementStats(BuildContext context, progress) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildEngagementRow(
              context,
              Icons.calendar_today,
              'Login Streak',
              '${progress.loginStreak} days',
              AppColors.primaryColor,
            ),
            const Divider(height: 24),
            _buildEngagementRow(
              context,
              Icons.school,
              'Lessons Completed',
              progress.pillarProgress.values
                  .fold(0, (sum, p) => sum + p.lessonsCompleted)
                  .toString(),
              AppColors.economicsColor,
            ),
            const Divider(height: 24),
            _buildEngagementRow(
              context,
              Icons.quiz,
              'Quizzes Completed',
              progress.pillarProgress.values
                  .fold(0, (sum, p) => sum + p.quizzesCompleted)
                  .toString(),
              AppColors.managementColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }

  Widget _buildXPChart(BuildContext context, progress) {
    final currentLevelXP = AppConstants.getXPForLevel(progress.level);
    final nextLevelXP = AppConstants.getXPForLevel(progress.level + 1);
    final xpInCurrentLevel = progress.xp - currentLevelXP;
    final xpNeededForNextLevel = nextLevelXP - currentLevelXP;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 60,
                  sections: [
                    PieChartSectionData(
                      value: xpInCurrentLevel.toDouble(),
                      title: 'Earned\n$xpInCurrentLevel XP',
                      radius: 50,
                      color: AppColors.xpColor,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: (xpNeededForNextLevel - xpInCurrentLevel).toDouble(),
                      title: 'Needed\n${xpNeededForNextLevel - xpInCurrentLevel} XP',
                      radius: 50,
                      color: Colors.grey[300],
                      titleStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Keep learning to reach Level ${progress.level + 1}!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
