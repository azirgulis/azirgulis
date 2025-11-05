import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/achievement_model.dart';
import '../../../../data/achievements/achievement_definitions.dart';
import '../../../../providers/achievement_provider.dart';
import '../../../../core/theme/app_colors.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AchievementCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(achievementStatsProvider);
    final unlockedAsync = ref.watch(unlockedAchievementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Unlocked'),
            Tab(text: 'Locked'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Stats Header
          statsAsync.when(
            data: (stats) => _buildStatsHeader(stats),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox(),
          ),

          // Category Filter
          _buildCategoryFilter(),

          // Achievement List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAchievementList(null), // All
                _buildAchievementList(true), // Unlocked only
                _buildAchievementList(false), // Locked only
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader(Map<String, dynamic> stats) {
    final totalUnlocked = stats['totalUnlocked'] as int;
    final totalAchievements = stats['totalAchievements'] as int;
    final percentage = stats['percentageComplete'] as int;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.1),
            AppColors.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.emoji_events,
                  color: AppColors.primaryColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Achievement Progress',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '$totalUnlocked of $totalAchievements unlocked',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Text(
                '$percentage%',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
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
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildCategoryChip('All', null),
          ...AchievementCategory.values.map((category) {
            return _buildCategoryChip(_getCategoryLabel(category), category);
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, AchievementCategory? category) {
    final isSelected = _selectedCategory == category;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? category : null;
          });
        },
        backgroundColor: Colors.grey.withOpacity(0.1),
        selectedColor: AppColors.primaryColor.withOpacity(0.2),
        checkmarkColor: AppColors.primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primaryColor : null,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  String _getCategoryLabel(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.levelMilestone:
        return 'Levels';
      case AchievementCategory.subjectMastery:
        return 'Mastery';
      case AchievementCategory.quizPerformance:
        return 'Quizzes';
      case AchievementCategory.social:
        return 'Social';
      case AchievementCategory.dailyEngagement:
        return 'Daily';
      case AchievementCategory.ismContent:
        return 'ISM';
      case AchievementCategory.miniGameMaster:
        return 'Games';
      case AchievementCategory.special:
        return 'Special';
    }
  }

  Widget _buildAchievementList(bool? unlockedFilter) {
    final unlockedAsync = ref.watch(unlockedAchievementsProvider);

    return unlockedAsync.when(
      data: (unlockedIds) {
        List<AchievementModel> achievements =
            AchievementDefinitions.getAllAchievements();

        // Filter by category
        if (_selectedCategory != null) {
          achievements = achievements
              .where((a) => a.category == _selectedCategory)
              .toList();
        }

        // Filter by unlock status
        if (unlockedFilter != null) {
          achievements = achievements.where((a) {
            final isUnlocked = unlockedIds.contains(a.id);
            return unlockedFilter ? isUnlocked : !isUnlocked;
          }).toList();
        }

        if (achievements.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events,
                  size: 80,
                  color: Colors.grey.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'No achievements found',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            final isUnlocked = unlockedIds.contains(achievement.id);
            return _buildAchievementCard(achievement, isUnlocked);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading achievements: $error'),
      ),
    );
  }

  Widget _buildAchievementCard(AchievementModel achievement, bool isUnlocked) {
    final progress = isUnlocked
        ? 1.0
        : ref.watch(achievementProgressProvider(achievement));

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Opacity(
        opacity: isUnlocked ? 1.0 : 0.6,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _getRarityColor(achievement.rarity)
                          .withOpacity(isUnlocked ? 0.2 : 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _getRarityColor(achievement.rarity),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        isUnlocked
                            ? _getIconData(achievement.iconName)
                            : Icons.lock,
                        color: _getRarityColor(achievement.rarity),
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rarity badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getRarityColor(achievement.rarity),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getRarityLabel(achievement.rarity),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Title
                        Text(
                          achievement.title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),

                        // Description
                        Text(
                          achievement.description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  // Checkmark for unlocked
                  if (isUnlocked)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.successColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: AppColors.successColor,
                        size: 20,
                      ),
                    ),
                ],
              ),

              // Progress bar for locked achievements
              if (!isUnlocked && progress > 0) ...[
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress: ${(progress * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getRarityColor(achievement.rarity),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              // Rewards
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.card_giftcard, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  if (achievement.coinsReward > 0) ...[
                    Icon(
                      Icons.monetization_on,
                      size: 16,
                      color: AppColors.coinsColor,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '+${achievement.coinsReward}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.coinsColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (achievement.xpReward > 0) ...[
                    Icon(
                      Icons.stars,
                      size: 16,
                      color: AppColors.xpColor,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '+${achievement.xpReward}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.xpColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (achievement.gemsReward > 0) ...[
                    Icon(
                      Icons.diamond,
                      size: 16,
                      color: AppColors.gemsColor,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '+${achievement.gemsReward}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gemsColor,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRarityColor(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return AppColors.badgeCommon;
      case AchievementRarity.rare:
        return AppColors.badgeRare;
      case AchievementRarity.epic:
        return AppColors.badgeEpic;
      case AchievementRarity.legendary:
        return AppColors.badgeLegendary;
    }
  }

  String _getRarityLabel(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return 'COMMON';
      case AchievementRarity.rare:
        return 'RARE';
      case AchievementRarity.epic:
        return 'EPIC';
      case AchievementRarity.legendary:
        return 'LEGENDARY';
    }
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'emoji_events':
        return Icons.emoji_events;
      case 'school':
        return Icons.school;
      case 'check_circle':
        return Icons.check_circle;
      case 'trending_up':
        return Icons.trending_up;
      case 'psychology':
        return Icons.psychology;
      case 'business_center':
        return Icons.business_center;
      case 'campaign':
        return Icons.campaign;
      case 'grade':
        return Icons.grade;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'flash_on':
        return Icons.flash_on;
      case 'sports_esports':
        return Icons.sports_esports;
      case 'group':
        return Icons.group;
      case 'leaderboard':
        return Icons.leaderboard;
      case 'calendar_today':
        return Icons.calendar_today;
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'nightlight':
        return Icons.nightlight;
      case 'apartment':
        return Icons.apartment;
      case 'auto_stories':
        return Icons.auto_stories;
      case 'speed':
        return Icons.speed;
      case 'done_all':
        return Icons.done_all;
      case 'diamond':
        return Icons.diamond;
      case 'attach_money':
        return Icons.attach_money;
      default:
        return Icons.star;
    }
  }
}
